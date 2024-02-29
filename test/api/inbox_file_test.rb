# frozen_string_literal: true

require "test_helper"

class Fakturoid::Api::InboxFileTest < Fakturoid::TestCase
  should "get all" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, filename: "attachment.pdf" }]
      stub.get("inbox_files.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.inbox_file.all.body.size
  end

  should "create new record" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, filename: "attachment.pdf" }
      stub.post("inbox_files.json") { |_env| [201, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.inbox_file.create(attachment: "data:application/pdf;base64,dGVzdA==").id
  end

  should "send to ocr" do
    mock_faraday_connection do |stub|
      stub.post("inbox_files/1/send_to_ocr.json") { |_env| [204, {}, ""] }
    end

    assert_equal 204, test_client.inbox_file.send_to_ocr(1).status_code
  end

  should "download" do
    mock_faraday_connection(headers: { content_type: "application/pdf" }) do |stub|
      stub.get("inbox_files/1/download") { |_env| [200, { content_type: "application/pdf" }, load_fixture("invoice.pdf")] }
    end

    response = test_client.inbox_file.download(1)
    assert !response.json?
    assert_equal 35_438, response.body.size
  end

  should "delete record" do
    mock_faraday_connection do |stub|
      stub.delete("inbox_files/1.json") { |_env| [204, {}, ""] }
    end

    assert_equal 204, test_client.inbox_file.delete(1).status_code
  end
end
