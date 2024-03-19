# frozen_string_literal: true

require "test_helper"

class Fakturoid::Api::EventTest < Fakturoid::TestCase
  should "get all" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, name: "invoice_sent" }]
      stub.get("events.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.events.all.body.size
  end

  should "get paid" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, name: "invoice_paid" }]
      stub.get("events/paid.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.events.paid.body.size
  end
end
