# frozen_string_literal: true

require "test_helper"

class Fakturoid::Api::ExpenseTest < Fakturoid::TestCase
  should "get all" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, number: "N20240201" }]
      stub.get("expenses.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.expenses.all.body.size
  end

  should "search by query" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, number: "N20240201" }]
      stub.strict_mode = true
      stub.get("expenses/search.json?query=N20240201", content_type: "application/json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.expenses.search(query: "N20240201").body.size
  end

  should "search by tags" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, number: "N20240201" }]
      stub.strict_mode = true
      stub.get("expenses/search.json?tags%5B%5D=Housing", content_type: "application/json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.expenses.search(tags: ["Housing"]).body.size
  end

  should "get detail" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, number: "N20240201" }
      stub.get("expenses/1.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.expenses.find(1).id
  end

  should "download attachment" do
    mock_faraday_connection(headers: { content_type: "application/pdf" }) do |stub|
      stub.get("expenses/1/attachments/2/download") { |_env| [200, { content_type: "application/pdf" }, load_fixture("invoice.pdf")] }
    end

    response = test_client.expenses.download_attachment(1, 2)
    assert !response.json?
    assert_equal 35_438, response.body.size
  end

  should "fire action" do
    mock_faraday_connection do |stub|
      stub.post("expenses/1/fire.json?event=lock") { |_env| [204, {}, ""] }
    end

    assert_equal 204, test_client.expenses.fire(1, "lock").status_code
  end

  should "create new record" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, number: "N20240201" }
      stub.post("expenses.json") { |_env| [201, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.expenses.create(subject_id: 1, lines: [{ name: "Workshop", unit_price: 1000, vat_rate: 21 }]).id
  end

  should "update record" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, number: "N20240201" }
      stub.patch("expenses/1.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.expenses.update(1, lines: [{ id: 1236, name: "Workshop 2" }]).id
  end

  should "delete record" do
    mock_faraday_connection do |stub|
      stub.delete("expenses/1.json") { |_env| [204, {}, ""] }
    end

    assert_equal 204, test_client.expenses.delete(1).status_code
  end
end
