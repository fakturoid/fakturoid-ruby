# frozen_string_literal: true

require "test_helper"

class Fakturoid::Api::ExpenseTest < Fakturoid::TestCase
  should "get all" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, number: "N20240201" }]
      stub.get("expenses.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.expense.all.body.size
  end

  should "search by query" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, number: "N20240201" }]
      stub.get("expenses/search.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.expense.search(query: "N20240201").body.size
  end

  should "search by tags" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, number: "N20240201" }]
      stub.get("expenses/search.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.expense.search(tags: ["Housing"]).body.size
  end

  should "get detail" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, number: "N20240201" }
      stub.get("expenses/1.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.expense.find(1).id
  end

  should "fire action" do
    mock_faraday_connection do |stub|
      stub.post("expenses/1/fire.json?event=lock") { |_env| [204, {}, ""] }
    end

    assert_equal 204, test_client.expense.fire(1, "lock").status_code
  end

  should "create new record" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, number: "N20240201" }
      stub.post("expenses.json") { |_env| [201, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.expense.create(subject_id: 1, lines: [{ name: "Workshop", unit_price: 1000, vat_rate: 21 }]).id
  end

  should "update record" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, number: "N20240201" }
      stub.patch("expenses/1.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.expense.update(1, lines: [{ id: 1236, name: "Workshop 2" }]).id
  end

  should "delete record" do
    mock_faraday_connection do |stub|
      stub.delete("expenses/1.json") { |_env| [204, {}, ""] }
    end

    assert_equal 204, test_client.expense.delete(1).status_code
  end
end
