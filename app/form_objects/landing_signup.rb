class LandingSignup
  include ActiveModel::Model
  REQUIRED_FIELDS = %i[current_city current_location from_group_age email password].freeze
  OPTIONAL_FIELDS = %i[to_location].freeze
  FIELDS = REQUIRED_FIELDS + OPTIONAL_FIELDS
  attr_accessor(*FIELDS)
  attr_reader :user, :move, :existing_user
  # other helpers: :notice, :alert

  validates(*REQUIRED_FIELDS, presence: true)
  # rubocop:disable Style/ColonMethodCall
  validates_format_of :email, with: Devise::email_regexp
  # rubocop:enable Style/ColonMethodCall

  def perform
    return false unless valid?
    return false unless _create_or_find_user?
    return false unless _create_move!

    UserMailer.landing_signup(@move).deliver_now
    true
  end

  def _create_or_find_user?
    if User.find_by email: @email
      _valid_existing_user?
    else
      @user = User.new email: @email, password: @password
      @user.skip_confirmation_notification! # we will manually send confirmation
      if @user.valid?
        true
      else
        errors.add :base, @user.errors.full_messages.join(', ')
        false
      end
    end
  end

  def _valid_existing_user?
    user = User.find_by email: @email
    if user.valid_password? password
      @user = user
      @existing_user = true
      true
    else
      errors.add :password, :invalid
      errors.add :base, :user_registered_but_password_is_invalid
      false
    end
  end

  def _create_move!
    current_location = Location.find @current_location
    from_group = Group.find_or_create_by_location_id_and_age(current_location.id, @from_group_age)
    @move = Move.create! user: @user, from_group: from_group
    if @to_location.present?
      to_location = Location.find @to_location
      to_group = to_location.groups.find_by age: @from_group_age
      result = AddToGroupAndSendNotifications.new(@move, to_group).perform
      errors.add :base, result.message unless result.success?
      # do not return false since we just procceed with a notice
    end
    true
  end

  def notice
    notice = I18n.t('activemodel.models.landing_signup.success_notice')
    notice += ' ' + I18n.t('devise.registrations.signed_up_but_unconfirmed') unless user.confirmed?
    notice += ' ' + @errors.full_messages.join(', ') if @errors.present?
    notice
  end

  # return hash {city_id: [{id: l1.id, name: l1.name_with_address}, ...], ...}
  def self.locations_by_city_id
    Location.all.each_with_object({}) do |location, result|
      if result[location.city_id].present?
        result[location.city_id].append(id: location.id, name: location.name_with_address)
      else
        result[location.city_id] = [{ id: location.id, name: location.name_with_address }]
      end
    end
  end

  # return hash {location_id: [{id: group.id, name: group.age_with_title}, ...], ...}
  def self.groups_by_location_id
    Group.all.each_with_object({}) do |group, result|
      if result[group.location_id].present?
        result[group.location_id].append(id: group.id, name: group.age_with_title)
      else
        result[group.location_id] = [{ id: group.id, name: group.age_with_title }]
      end
    end
  end

  # return hash {group_id: [id: group.id, name: group.location.name_with_address}, ...]...}
  # groups on other locations from same city, with same age
  def self.groups_by_group_id
    Group.all.each_with_object({}) do |group, result|
      groups = group
               .query_as(:g)
               .match(
                 '(g)<-[:HAS_GROUPS]-(l),
                 (l)-[:IN_CITY]->(c),(c)<-[:IN_CITY]-(other_loc),
                 (other_loc)-[:HAS_GROUPS]->(other_group)'
               )
               .where('g <> other_group').where('g.age = other_group.age')
               .pluck(:other_group, :other_loc)
               .map { |g, l| { id: g.id, name: l.name_with_address } }
      result[group.id] = groups
    end
  end
end
