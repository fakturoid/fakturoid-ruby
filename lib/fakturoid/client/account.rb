module Fakturoid
  module Client
    class Account < Fakturoid::Api
      def self.get
        get_request('account.json')
      end
    end
  end
end