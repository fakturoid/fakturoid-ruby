module Fakturoid
  module Client
    class User < Api
      def self.get
        get_request('user.json', url: Fakturoid::Api.config.endpoint_without_account)
      end
    end
  end
end