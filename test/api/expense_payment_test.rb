# frozen_string_literal: true

require "test_helper"

class Fakturoid::Api::ExpensePaymentTest < Fakturoid::TestCase
  should "create new record" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, paid_on: "2024-02-29" }
      stub.post("expenses/1/payments.json") { |_env| [201, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.expense_payments.create(1, paid_on: Date.today).id
  end

  should "delete record" do
    mock_faraday_connection do |stub|
      stub.delete("expenses/1/payments/2.json") { |_env| [204, {}, ""] }
    end

    assert_equal 204, test_client.expense_payments.delete(1, 2).status_code
  end
end
