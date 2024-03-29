# frozen_string_literal: true

require "test_helper"

class Fakturoid::Api::InventoryItemTest < Fakturoid::TestCase
  should "get all" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, name: "Chair" }]
      stub.get("inventory_items.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.inventory_items.all.body.size
  end

  should "get archived" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, name: "Chair" }]
      stub.get("inventory_items/archived.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.inventory_items.archived.body.size
  end

  should "get low_quantity" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, name: "Chair" }]
      stub.get("inventory_items/low_quantity.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.inventory_items.low_quantity.body.size
  end

  should "search" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, name: "Chair" }]
      stub.strict_mode = true
      stub.get("inventory_items/search.json?query=Chair", content_type: "application/json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.inventory_items.search(query: "Chair").body.size
  end

  should "get detail" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, name: "Chair" }
      stub.get("inventory_items/1.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.inventory_items.find(1).id
  end

  should "create new record" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, name: "Chair" }
      stub.post("inventory_items.json") { |_env| [201, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.inventory_items.create(name: "Chair", native_retail_price: "1000").id
  end

  should "update record" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, name: "Table" }
      stub.patch("inventory_items/1.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.inventory_items.update(1, name: "Table").id
  end

  should "delete record" do
    mock_faraday_connection do |stub|
      stub.delete("inventory_items/1.json") { |_env| [204, {}, ""] }
    end

    assert_equal 204, test_client.inventory_items.delete(1).status_code
  end

  should "archive" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, name: "Chair", archived: true }
      stub.post("inventory_items/1/archive.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.inventory_items.archive(1).id
  end

  should "unarchive" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, name: "Chair", archived: false }
      stub.post("inventory_items/1/unarchive.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.inventory_items.unarchive(1).id
  end
end
