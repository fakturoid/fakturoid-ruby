# frozen_string_literal: true

require "test_helper"

class Fakturoid::Api::InventoryMoveTest < Fakturoid::TestCase
  should "get all" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, moved_on: "2024-02-29" }]
      stub.get("inventory_moves.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.inventory_moves.all.body.size
  end

  should "get all for single inventory item" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, moved_on: "2024-02-29" }]
      stub.get("inventory_moves.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.inventory_moves.all(inventory_item_id: 1).body.size
  end

  should "get detail" do
    mock_faraday_connection do |stub|
      response_data = { id: 2, moved_on: "2024-02-29" }
      stub.get("inventory_items/1/inventory_moves/2.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 2, test_client.inventory_moves.find(1, 2).id
  end

  should "create new record" do
    mock_faraday_connection do |stub|
      response_data = { id: 2, moved_on: "2024-02-29" }
      stub.post("inventory_items/1/inventory_moves.json") { |_env| [201, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 2, test_client.inventory_moves.create(1, direction: "out", moved_on: Date.today, quantity_change: 1).id
  end

  should "update record" do
    mock_faraday_connection do |stub|
      response_data = { id: 2, moved_on: "2024-03-01" }
      stub.patch("inventory_items/1/inventory_moves/2.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 2, test_client.inventory_moves.update(1, 2, moved_on: Date.today + 1).id
  end

  should "delete record" do
    mock_faraday_connection do |stub|
      stub.delete("inventory_items/1/inventory_moves/2.json") { |_env| [204, {}, ""] }
    end

    assert_equal 204, test_client.inventory_moves.delete(1, 2).status_code
  end
end
