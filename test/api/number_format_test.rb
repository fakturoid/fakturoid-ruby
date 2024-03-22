# frozen_string_literal: true

require "test_helper"

class Fakturoid::Api::NumberFormatTest < Fakturoid::TestCase
  should "get invoices" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, format: "#yyyy#-#dddd#" }]
      stub.get("number_formats/invoices.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.number_formats.invoices.body.size
  end
end
