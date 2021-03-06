require 'test_helper'

class OmniauthCallbacksControllerTest < ActionDispatch::IntegrationTest
  def setup
    OmniAuth.config.test_mode = true
  end

  def teardown
    OmniAuth.config.mock_auth[:google_oauth2] = nil
    OmniAuth.config.mock_auth[:facebook] = nil
    OmniAuth.config.test_mode = false
  end

  test 'facebook login' do
    facebook_uid = SecureRandom.hex
    user = create :user, facebook_uid: facebook_uid
    OmniAuth.config.add_mock :facebook, uid: facebook_uid

    get dashboard_path
    assert_response :redirect
    get user_facebook_omniauth_authorize_path
    follow_redirect!
    follow_redirect!
    assert_select '#userDropdown', user.email_username
  end

  test 'google login' do
    google_uid = SecureRandom.hex
    user = create :user, google_uid: google_uid
    OmniAuth.config.add_mock :google_oauth2, uid: google_uid

    get user_google_oauth2_omniauth_authorize_path
    follow_redirect!
    follow_redirect!
    assert_select '#userDropdown', user.email_username
    assert_select '#notice-debug', t('devise.omniauth_callbacks.success', kind: t('provider.google_oauth2'))
  end

  test 'facebook signup' do
    email = 'my@email.com'
    OmniAuth.config.add_mock :facebook, info: { email: email }, uid: '123'
    assert_difference 'User.count', 1 do
      assert_performed_jobs 1, only: ActionMailer::DeliveryJob do
        get user_facebook_omniauth_authorize_path
        follow_redirect!
        follow_redirect!
        assert_select '#userDropdown', 'my'
      end
    end
    user = User.find_by email: email
    assert_equal '123', user.facebook_uid
    refute user.confirmed?
  end

  test 'facebook email already exists update facebook_uid' do
    email = 'my@email.com'
    create :user, email: email, facebook_uid: '000'
    OmniAuth.config.add_mock :facebook, info: { email: email }, uid: 'new_uid'
    assert_difference 'User.count', 0 do
      get user_facebook_omniauth_authorize_path
      follow_redirect!
      follow_redirect!
      assert_select '#userDropdown', 'my'
    end
    user = User.find_by email: email
    assert_equal 'new_uid', user.facebook_uid
  end

  test 'facebook signup existing user but email changed on facebook' do
    email = 'my@email.com'
    uid = SecureRandom.hex
    create :user, email: email, facebook_uid: uid
    OmniAuth.config.add_mock :facebook, info: { email: 'updated@email.com' }, uid: uid
    assert_difference 'User.count', 0 do
      get user_facebook_omniauth_authorize_path
      follow_redirect!
      follow_redirect!
    end
    user = User.find_by facebook_uid: uid
    assert_equal 'updated@email.com', user.email
  end

  test 'facebook without email' do
    OmniAuth.config.add_mock :facebook, info: {}
    assert_difference 'User.count', 0 do
      get user_facebook_omniauth_authorize_path
      follow_redirect!
      follow_redirect!
      assert_select 'input[type=email]'
      assert_alert_message Regexp.new t('errors.messages.blank')
    end
  end

  def silence_omniauth
    previous_logger = OmniAuth.config.logger
    OmniAuth.config.logger = Logger.new('/dev/null')
    yield
  ensure
    OmniAuth.config.logger = previous_logger
  end

  test 'failure' do
    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    assert_difference 'User.count', 0 do
      get user_facebook_omniauth_authorize_path
      silence_omniauth { follow_redirect! }
      follow_redirect!
      assert_select 'div', /invalid_credentials/
    end
  end
end
