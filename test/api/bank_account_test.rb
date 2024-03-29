# frozen_string_literal: true

require "test_helper"

class Fakturoid::Api::BankAccountTest < Fakturoid::TestCase
  should "get all" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, name: "Bank account" }]
      stub.get("bank_accounts.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.bank_accounts.all.body.size
  end
end
