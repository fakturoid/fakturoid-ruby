# frozen_string_literal: true

require "test_helper"

class Fakturoid::Api::InvoiceTest < Fakturoid::TestCase
  should "get all" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, number: "2024-0001" }]
      stub.get("invoices.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert 1, test_client.invoice.all.body.size
  end

  should "search" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, number: "2024-0001" }]
      stub.get("invoices/search.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert 1, test_client.invoice.search("2024-0001").body.size
  end

  should "get detail" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, number: "2024-0001" }
      stub.get("invoices/1.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert 1, test_client.invoice.find(1).id
  end

  should "download pdf" do
    mock_faraday_connection(headers: { content_type: "application/pdf" }) do |stub|
      stub.get("invoices/1/download.pdf") { |_env| [200, { content_type: "application/pdf" }, load_fixture("invoice.pdf")] }
    end

    response = test_client.invoice.download_pdf(1)
    assert !response.json?
    assert 35_438, response.body.size
  end
end
