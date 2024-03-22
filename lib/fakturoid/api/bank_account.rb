# frozen_string_literal: true

module Fakturoid
  module Api
    class BankAccount
      include Base

      def all
        perform_request(HTTP_GET, "bank_accounts.json")
      end
    end
  end
end
