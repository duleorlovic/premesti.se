require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'landing_signup' do
    move = create :move
    mail = UserMailer.landing_signup(move)
    assert_equal t('user_mailer.landing_signup.subject'), mail.subject
    assert_equal [move.user.email], mail.to
    assert Rails.application.secrets.mailer_sender.include?(mail.from.first)
    assert_match t('hi_name', name: move.user.email), mail.body.encoded
    refute_match t('user_mailer.landing_signup.confirmation_text'), mail.body.encoded
  end

  test 'landing_signup with condirmation link' do
    user = create :user, confirmed_at: nil
    move = create :move, user: user
    mail = UserMailer.landing_signup(move)
    assert_match t('user_mailer.landing_signup.confirmation_text'), mail.body.encoded
  end
end
