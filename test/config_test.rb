# frozen_string_literal: true

require "test_helper"

class Fakturoid::ConfigTest < Fakturoid::TestCase
  should "configure client credentials flow with block param" do
    config = Fakturoid::Config.new do |c|
      c.email = "test@email.cz"
      c.account = "testaccount"
      c.user_agent = "My test app (test@email.cz)"
      c.client_id = "XXX"
      c.client_secret = "YYY"
      c.oauth_flow = "client_credentials"
    end

    assert_equal "test@email.cz", config.email
    assert_equal "testaccount", config.account
    assert_equal "My test app (test@email.cz)", config.user_agent
    assert_equal "XXX", config.client_id
    assert_equal "YYY", config.client_secret
    assert_equal "client_credentials", config.oauth_flow
    assert config.client_credentials_flow?
    assert !config.authorization_code_flow?
  end

  should "configure authorization code flow with block param" do
    config = Fakturoid::Config.new do |c|
      c.email = "test@email.cz"
      c.account = "testaccount"
      c.user_agent = "My test app (test@email.cz)"
      c.client_id = "XXX"
      c.client_secret = "YYY"
      c.oauth_flow = "authorization_code"
      c.redirect_uri = "http://example.org/redirect"
    end

    assert_equal "test@email.cz", config.email
    assert_equal "testaccount", config.account
    assert_equal "My test app (test@email.cz)", config.user_agent
    assert_equal "XXX", config.client_id
    assert_equal "YYY", config.client_secret
    assert_equal "authorization_code", config.oauth_flow
    assert_equal "http://example.org/redirect", config.redirect_uri
    assert !config.client_credentials_flow?
    assert config.authorization_code_flow?
  end

  should "use authorization code flow specific methods" do
    config = Fakturoid::Config.new do |c|
      c.email = "test@email.cz"
      c.account = "testaccount"
      c.user_agent = "My test app (test@email.cz)"
      c.client_id = "XXX"
      c.client_secret = "YYY"
      c.oauth_flow = "authorization_code"
      c.redirect_uri = "http://example.org/redirect"
    end

    response = OpenStruct.new(
      access_token: "access",
      refresh_token: "refresh",
      token_type: "Bearer",
      expires_at: Time.now.to_i + 2 * 3600 - 10
    )
    config.update_oauth_tokens(response)

    assert_equal URI.parse("https://app.fakturoid.cz/api/v3/oauth?client_id=XXX&redirect_uri=http%3A%2F%2Fexample.org%2Fredirect&response_type=code"), config.authorization_uri
    assert_equal URI.parse("https://app.fakturoid.cz/api/v3/oauth?client_id=XXX&redirect_uri=http%3A%2F%2Fexample.org%2Fredirect&response_type=code&state=abcd1234"), config.authorization_uri(state: "abcd1234")
    assert_equal "Bearer access", config.access_token_auth_header
  end

  should "use default user agent" do
    config = Fakturoid::Config.new do |c|
      c.email = "test@email.cz"
      c.account = "testaccount"
      c.client_id = "XXX"
      c.client_secret = "YYY"
      c.oauth_flow = "client_credentials"
    end

    assert_equal "Fakturoid ruby gem (test@email.cz)", config.user_agent
  end

  should "return correct endpoints" do
    config = Fakturoid::Config.new do |c|
      c.email = "test@email.cz"
      c.account = "testaccount"
      c.client_id = "XXX"
      c.client_secret = "YYY"
      c.oauth_flow = "client_credentials"
    end

    assert_equal "https://app.fakturoid.cz/api/v3/accounts/testaccount", config.api_endpoint
    assert_equal "https://app.fakturoid.cz/api/v3", config.api_endpoint_without_account
    assert_equal "https://app.fakturoid.cz/api/v3/oauth", config.oauth_endpoint
  end

  should "raise an error if flow is unsupported" do
    assert_raises(Fakturoid::ConfigurationError) do
      Fakturoid::Config.new do |c|
        c.oauth_flow = "unsupported"
      end
    end
  end

  should "raise an error if email is missing" do
    assert_raises(Fakturoid::ConfigurationError) do
      Fakturoid::Config.new do |c|
        c.oauth_flow = "client_credentials"
      end
    end
  end

  should "raise an error if client_id is missing" do
    assert_raises(Fakturoid::ConfigurationError) do
      Fakturoid::Config.new do |c|
        c.email = "test@email.cz"
        c.client_secret = "YYY"
        c.oauth_flow = "client_credentials"
      end
    end
  end

  should "raise an error if client_secret is missing" do
    assert_raises(Fakturoid::ConfigurationError) do
      Fakturoid::Config.new do |c|
        c.email = "test@email.cz"
        c.client_id = "XXX"
        c.oauth_flow = "client_credentials"
      end
    end
  end

  should "raise an error if redirect_uri is missing" do
    assert_raises(Fakturoid::ConfigurationError) do
      Fakturoid::Config.new do |c|
        c.email = "test@email.cz"
        c.account = "testaccount"
        c.user_agent = "My test app (test@email.cz)"
        c.client_id = "XXX"
        c.client_secret = "YYY"
        c.oauth_flow = "authorization_code"
      end
    end
  end
end
