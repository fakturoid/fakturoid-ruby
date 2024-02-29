# frozen_string_literal: true

require "test_helper"

class Fakturoid::Api::UserTest < Fakturoid::TestCase
  should "get current" do
    mock_faraday_connection do |stub|
      response_data = { id: 5, full_name: "Alexandr Hejsek" }
      stub.get("user.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 5, test_client.user.current.id
  end

  should "get all" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 5, full_name: "Alexandr Hejsek" }]
      stub.get("users.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.user.all.body.size
  end
end
