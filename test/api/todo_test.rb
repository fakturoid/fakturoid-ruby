# frozen_string_literal: true

require "test_helper"

class Fakturoid::Api::TodoTest < Fakturoid::TestCase
  should "get all" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, name: "invoice_paid" }]
      stub.get("todos.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.todos.all.body.size
  end

  should "toggle completion" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, name: "Chair", archived: true }
      stub.post("todos/1/toggle_completion.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.todos.toggle_completion(1).id
  end
end
