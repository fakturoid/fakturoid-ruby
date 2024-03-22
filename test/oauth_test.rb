# frozen_string_literal: true

require "test_helper"

class Fakturoid::OauthTest < Fakturoid::TestCase
  should "build authorization uri" do
    Fakturoid.configure do |config|
      config.email         = "test@email.cz"
      config.account       = "testaccount"
      config.user_agent    = "My test app (test@email.cz)"
      config.client_id     = "XXX"
      config.client_secret = "YYY"
      config.redirect_uri  = "https://example.org/redirect"
      config.oauth_flow    = "authorization_code"
    end

    client = Fakturoid.client

    uri = URI.parse("https://app.fakturoid.cz/api/v3/oauth?client_id=XXX&redirect_uri=https%3A%2F%2Fexample.org%2Fredirect&response_type=code")
    assert_equal uri, client.authorization_uri

    uri = URI.parse("https://app.fakturoid.cz/api/v3/oauth?client_id=XXX&redirect_uri=https%3A%2F%2Fexample.org%2Fredirect&response_type=code&state=abcd123")
    assert_equal uri, client.authorization_uri(state: "abcd123")
  end
end
