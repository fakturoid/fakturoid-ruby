# frozen_string_literal: true

require "test_helper"

class Fakturoid::Api::InvoiceTest < Fakturoid::TestCase
  should "get all" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, number: "2024-0001" }]
      stub.get("invoices.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.invoices.all.body.size
  end

  should "search by query" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, number: "2024-0001" }]
      stub.strict_mode = true
      stub.get("invoices/search.json?query=2024-0001", content_type: "application/json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.invoices.search(query: "2024-0001").body.size
  end

  should "search by tags" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, number: "2024-0001" }]
      stub.strict_mode = true
      stub.get("invoices/search.json?tags%5B%5D=Housing", content_type: "application/json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.invoices.search(tags: ["Housing"]).body.size
  end

  should "get detail" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, number: "2024-0001" }
      stub.get("invoices/1.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.invoices.find(1).id
  end

  should "download pdf" do
    mock_faraday_connection(headers: { content_type: "application/pdf" }) do |stub|
      stub.get("invoices/1/download.pdf") { |_env| [200, { content_type: "application/pdf" }, load_fixture("invoice.pdf")] }
    end

    response = test_client.invoices.download_pdf(1)
    assert !response.json?
    assert_equal 35_438, response.body.size
  end

  should "download attachment" do
    mock_faraday_connection(headers: { content_type: "application/pdf" }) do |stub|
      stub.get("invoices/1/attachments/2/download") { |_env| [200, { content_type: "application/pdf" }, load_fixture("invoice.pdf")] }
    end

    response = test_client.invoices.download_attachment(1, 2)
    assert !response.json?
    assert_equal 35_438, response.body.size
  end

  should "fire action" do
    mock_faraday_connection do |stub|
      stub.post("invoices/1/fire.json?event=lock") { |_env| [204, {}, ""] }
    end

    assert_equal 204, test_client.invoices.fire(1, "lock").status_code
  end

  should "create new record" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, number: "2024-0001" }
      stub.post("invoices.json") { |_env| [201, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.invoices.create(subject_id: 1, lines: [{ name: "Workshop", unit_price: 1000, vat_rate: 21 }]).id
  end

  should "update record" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, number: "2024-0001" }
      stub.patch("invoices/1.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.invoices.update(1, lines: [{ id: 1236, name: "Workshop 2" }]).id
  end

  should "delete record" do
    mock_faraday_connection do |stub|
      stub.delete("invoices/1.json") { |_env| [204, {}, ""] }
    end

    assert_equal 204, test_client.invoices.delete(1).status_code
  end
end
