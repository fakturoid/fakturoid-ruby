# frozen_string_literal: true

require "test_helper"

class Fakturoid::Api::InvoiceMessageTest < Fakturoid::TestCase
  should "create new record" do
    mock_faraday_connection do |stub|
      stub.post("invoices/1/message.json") { |_env| [204, {}, ""] }
    end

    assert_equal 204, test_client.invoice_messages.create(1, paid_on: Date.today).status_code
  end
end
