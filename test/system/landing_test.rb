require "application_system_test_case"

class LandingTest < ApplicationSystemTestCase
  test 'create user and relationships' do
    skip
    group = create :group
    to_location = create :location, city: group.location.city
    to_group = create :group, location: to_location, age: group.age
    email = 'my@email.com'

    visit root_url
    # select group.location.city.name, from: t('neo4j.attributes.landing_signup.current_city')
    select2_ajax group.location.name_with_address, from: t('neo4j.attributes.landing_signup.current_location')
    select group.age_with_title, from: t('neo4j.attributes.landing_signup.from_group')
    select2_ajax to_location.name_with_address, from: t('neo4j.attributes.landing_signup.to_location')
    fill_in t('neo4j.attributes.landing_signup.email'), with: email
    fill_in t('neo4j.attributes.landing_signup.password'), with: '1234567'
    assert_difference "User.count", 1 do
      assert_difference "ActionMailer::Base.deliveries.size", 1 do
        click_on t('landing_signup.submit')
      end
    end

    user = User.find_by email: email
    assert_kind_of User, user
    refute user.confirmed?
    move = user.moves.last
    assert_equal group, move.from_group
    assert_equal [to_group], move.to_groups
    assert_selector 'a', text: t("sign_out")
    refute_selector 'a', text: t("register")
    click_on t("sign_out")
    assert_selector 'a', text: t("register")

    registration_email = ActionMailer::Base.deliveries.last
    assert_equal [email], registration_email.to
    confirmation_link = registration_email.html_part.decoded.match(
      /(http:.*)">#{t("confirm_email")}/
    )[1]
    visit confirmation_link
    user = User.find_by email: email
    assert user.confirmed?

    assert_selector 'a', text: t("sign_out")
    refute_selector 'a', text: t("register")
    ActionMailer::Base.deliveries.clear
  end
end
