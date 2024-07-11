# frozen_string_literal: true

require "test_helper"

class Fakturoid::Api::WebhookTest < Fakturoid::TestCase
  should "get all" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, webhook_url: "https://example.com/webhook" }]
      stub.get("webhooks.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.webhooks.all.body.size
  end

  should "get detail" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, webhook_url: "https://example.com/webhook" }
      stub.get("webhooks/1.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.webhooks.find(1).id
  end

  should "create new record" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, webhook_url: "https://example.com/webhook" }
      stub.post("webhooks.json") { |_env| [201, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.webhooks.create(webhook_url: "https://example.com/webhook", events: %w[invoice_created]).id
  end

  should "update record" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, webhook_url: "https://example.com/webhook" }
      stub.patch("webhooks/1.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.webhooks.update(1, webhook_url: "https://example.com/webhook").id
  end

  should "delete record" do
    mock_faraday_connection do |stub|
      stub.delete("webhooks/1.json") { |_env| [204, {}, ""] }
    end

    assert_equal 204, test_client.webhooks.delete(1).status_code
  end
end
