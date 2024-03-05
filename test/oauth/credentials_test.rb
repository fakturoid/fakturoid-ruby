# frozen_string_literal: true

require "test_helper"

class Fakturoid::Oauth::CredentialsTest < Fakturoid::TestCase
  should "work with Time" do
    credentials = Fakturoid::Oauth::Credentials.new(expires_at: Time.now + 2 * 3600)
    assert !credentials.access_token_near_expiration?
  end

  should "work with DateTime" do
    credentials = Fakturoid::Oauth::Credentials.new(expires_at: DateTime.now + (2.0 / 24))
    assert !credentials.access_token_near_expiration?
  end

  should "parse a Time string with 2 hours from now" do
    expires_at = (Time.now + 2 * 3600).to_s
    credentials = Fakturoid::Oauth::Credentials.new(expires_at: expires_at)
    assert !credentials.access_token_near_expiration?
  end

  should "parse a DateTime string with 2 hours from now" do
    expires_at = (DateTime.now + (2.0 / 24)).to_s
    credentials = Fakturoid::Oauth::Credentials.new(expires_at: expires_at)
    assert !credentials.access_token_near_expiration?
  end

  should "work with an integer" do
    credentials = Fakturoid::Oauth::Credentials.new(expires_in: 2 * 3600)
    assert !credentials.access_token_near_expiration?
  end

  should "raise an error if integer is unix timestamp and not number of seconds" do
    expires_at = Time.now.to_i + 2 * 3600
    assert_raises(ArgumentError) { Fakturoid::Oauth::Credentials.new(expires_at: expires_at) }
  end

  should "appear expired if a couple of seconds before real expiry time" do
    expires_at = Time.now + Fakturoid::Oauth::Credentials::EXPIRY_BUFFER_IN_SECONDS / 2
    credentials = Fakturoid::Oauth::Credentials.new(expires_at: expires_at)
    assert credentials.access_token_near_expiration?
  end

  should "be expired if in the past" do
    credentials = Fakturoid::Oauth::Credentials.new(expires_at: Time.now - 5 * 60)
    assert credentials.access_token_near_expiration?
  end
end
