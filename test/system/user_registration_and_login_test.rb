require 'application_system_test_case'
require 'helpers/system_login_helpers'

class UsersTest < ApplicationSystemTestCase
  include SystemLoginHelpers

  test 'register new user' do
    manual_register 'new@email.com', 'some_password'

    assert_text t('devise.registrations.signed_up')
    user = User.find_by email: 'new@email.com'
    assert_equal user.locale, 'en'
  end

  test 'register user already exists' do
    email = 'my@email.com'
    create :user, email: email
    manual_register email, 'some_password'
    assert_text t('neo4j.attributes.user.email') + ' ' + t('neo4j.errors.messages.taken')
  end

  test 'register already exists, email upercased' do
    create :user, email: 'my@email.com'
    manual_register 'mY@email.com', 'some_password'
    assert_text t('neo4j.attributes.user.email') + ' ' + t('neo4j.errors.messages.taken')
  end

  test 'register already exists, email not striped' do
    create :user, email: 'my@email.com'
    manual_register ' my@email.com ', 'some_password'
    assert_text t('neo4j.attributes.user.email') + ' ' + t('neo4j.errors.messages.taken')
  end

  test 'login' do
    email = 'my@email.com'
    password = '12345678'
    create :user, email: email, password: password
    manual_login email, password
    assert_selector '#userDropdown', text: 'my'
  end

  test 'login, email upercased' do
    password = '12345678'
    create :user, email: 'my@email.com', password: password
    manual_login 'my@eMail.com', password
    assert_selector '#userDropdown', text: 'my'
  end

  test 'login, email not striped' do
    password = '12345678'
    create :user, email: 'my@email.com', password: password
    manual_login ' my@email.com ', password
    assert_selector '#userDropdown', text: 'my'
  end

  test 'forgot password' do
    email = 'my@email.com'
    user = create :user, email: email
    visit new_user_password_path
    fill_in t('neo4j.attributes.user.email'), with: email
    perform_enqueued_jobs only: ActionMailer::DeliveryJob do
      click_on t('my_devise.send_me_reset_password_instructions')
    end

    assert_text t('devise.passwords.send_instructions')
    mail = give_me_last_mail_and_clear_mails
    link = mail.html_part.to_s.match("(http://.*)\">#{t('change_password')}")[1]
    visit link
    fill_in t('my_devise.new_password'), with: 'new_password'
    fill_in t('neo4j.attributes.user.password_confirmation'), with: 'new_password'
    click_on t('update')

    user.reload
    assert user.valid_password? 'new_password'
  end

  test 'resend confirmation instructions' do
    email = 'my@email.com'
    create :user, email: email, confirmed_at: nil
    visit new_user_confirmation_path
    fill_in t('neo4j.attributes.user.email'), with: email
    click_on t('send')

    assert_text t('devise.confirmations.send_instructions')
  end

  test 'resend unlock instructions' do
    return unless User.devise_modules.include?(:lockable) && User.unlock_strategy_enabled?(:email)
    email = 'my@email.com'
    create :user, email: email, locked_at: Time.zone.now
    visit new_user_unlock_path
    fill_in t('neo4j.attributes.user.email'), with: email
    click_on t('my_devise.resend_unlock_instructions')

    assert_text t('devise.unlocks.send_instructions')
  end

  test 'change password' do
    user = create :user, password: 'old_password'
    sign_in user
    visit edit_user_registration_path
    fill_in t('neo4j.attributes.user.current_password'), with: 'old_password'
    fill_in t('neo4j.attributes.user.password'), with: 'new_password'
    fill_in t('neo4j.attributes.user.password_confirmation'), with: 'new_password'
    click_on t('update')

    assert_text t('devise.registrations.updated')

    user.reload
    assert user.valid_password? 'new_password'
  end

  test 'change email' do
  end

  test 'destroy user' do
  end

  test 'change locale' do
    user = create :user
    sign_in user
    visit my_settings_path
    select 'Премести се (ћирилица)'
    click_on t('update')
    user.reload
    assert_equal user.locale, 'sr'
  end

  test 'register new user in non default url' do
    email = 'new@email.com'
    password = 'some_password'
    visit new_user_registration_url host: Constant::DOMAINS[:test][:sr]
    fill_in t('neo4j.attributes.user.email', locale: :sr), with: email
    fill_in t('neo4j.attributes.user.password', locale: :sr), with: password
    fill_in t('neo4j.attributes.user.password_confirmation', locale: :sr), with: password

    click_on t('register', locale: :sr)

    assert_text t('devise.registrations.signed_up', locale: :sr)
    user = User.find_by email: email
    assert_equal user.locale, 'sr'
  end
end