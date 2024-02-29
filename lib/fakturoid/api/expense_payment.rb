# frozen_string_literal: true

module Fakturoid
  module Api
    class ExpensePayment
      include Common::Base

      def create(expense_id, payload = {})
        Utils.validate_numerical_id(expense_id)
        perform_request(HTTP_POST, "expenses/#{expense_id}/payments.json", payload: payload)
      end

      def delete(expense_id, id)
        Utils.validate_numerical_id(expense_id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_DELETE, "expenses/#{expense_id}/payments/#{id}.json")
      end
    end
  end
end
