# frozen_string_literal: true

require "test_helper"

class Fakturoid::Api::AccountTest < Fakturoid::TestCase
  should "should get current" do
    mock_faraday_connection do |stub|
      response_data = { subdomain: "applecorp" }
      stub.get("account.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert "applecorp", test_client.account.current.subdomain
  end
end
