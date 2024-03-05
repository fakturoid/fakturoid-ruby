# frozen_string_literal: true

require "minitest/autorun"
require "mocha/minitest"
require "shoulda-context"
require "pathname"
require "fakturoid"

module Fakturoid
  class TestCase < Minitest::Test
    # Clean up global state.
    def teardown
      Fakturoid.instance_variable_set(:@client, nil)
      Fakturoid::Client.instance_variable_set(:@config, nil)
      Fakturoid::Client.instance_variable_set(:@oauth, nil)
    end

    def test_path
      Pathname.new(File.dirname(__FILE__))
    end

    def load_fixture(file_path)
      File.read(test_path.join("fixtures", file_path))
    end

    def mock_faraday_connection(params = {}, &block)
      raise ArgumentError, "No block given" unless block_given?

      [Fakturoid::Oauth::Request::Api].each do |klass|
        test_connection = Faraday.new do |builder|
          builder.adapter(:test, &block)
          builder.headers = params[:headers] || { content_type: "application/json" }
        end

        klass.any_instance.stubs(:connection).returns(test_connection)
      end
    end

    def test_client
      @test_client ||= begin
        Fakturoid.configure do |config|
          config.email         = "test@email.cz"
          config.account       = "testaccount"
          config.user_agent    = "My test app (test@email.cz)"
          config.client_id     = "XXX"
          config.client_secret = "YYY"
          config.oauth_flow    = "client_credentials"
        end

        Fakturoid.client.tap do |client|
          client.credentials = {
            access_token: "access",
            token_type: "Bearer",
            expires_at: Time.now + 2 * 3600
          }
        end
      end
    end
  end
end
