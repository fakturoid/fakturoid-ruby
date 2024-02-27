# frozen_string_literal: true

require "minitest/autorun"
require "mocha/minitest"
require "shoulda-context"
require "pathname"
require "fakturoid"

module Fakturoid
  class TestCase < Minitest::Test
    def test_path
      Pathname.new(File.dirname(__FILE__))
    end

    def load_fixture(file_path)
      File.read(test_path.join("fixtures", file_path))
    end

    def mock_faraday_connection(&block)
      raise ArgumentError, "No block given" unless block_given?

      [Fakturoid::Oauth::Request::Api].each do |klass|
        test_connection = Faraday.new do |builder|
          builder.adapter(:test, &block)
          builder.headers = { content_type: "application/json", accept: "application/json" }
        end

        klass.any_instance.stubs(:connection).returns(test_connection)
      end
    end

    def test_client
      @test_client ||= begin
        Fakturoid.configure do |c|
          c.email = "test@email.cz"
          c.account = "testaccount"
          c.user_agent = "My test app (test@email.cz)"
          c.client_id = "XXX"
          c.client_secret = "YYY"
          c.oauth_flow = "client_credentials"
        end

        response = OpenStruct.new(
          access_token: "access",
          token_type: "Bearer"
        )
        Fakturoid.client.config.update_oauth_tokens(response)

        Fakturoid.client
      end
    end
  end
end
