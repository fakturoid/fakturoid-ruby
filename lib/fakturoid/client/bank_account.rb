module Fakturoid
  module Client
    class BankAccount < Fakturoid::Api
      def self.all        
        get_request('bank_accounts.json')
      end
    end
  end
end