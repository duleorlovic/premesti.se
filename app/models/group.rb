class Group
  include Neo4j::ActiveNode
  property :name, type: String
  # age range is fixed, every year admin will update birth date range and send
  # notification to existing users about new chances, for example two new groups
  property :age, type: Integer
  # property :birth_date_min, type: Date
  # property :birth_date_max, type: Date
  has_one :in, :location, origin: :groups
  has_many :in, :move, origin: :group

  validates :location, presence: true
  validates :age, numericality: { greater_than: 0 }
  validate :age_overlaps

  def age_overlaps
    return unless age.to_i > 0
    return unless location
    return unless location.groups.for_age(age, id).present?
    errors.add :age, I18n.t('group_with_that_age_already_exists')
  end

  scope :for_age, ->(age, except_id) { where(age: age).where_not(id: except_id) }

  def age_with_title
    age_interval = "01.03.#{Time.zone.today.year - age - 1}-28.02.#{Time.zone.today.year - age}"
    "#{I18n.t("group_name_for_age_#{age}")} (#{I18n.t('born')} #{age_interval}"
  end
end
