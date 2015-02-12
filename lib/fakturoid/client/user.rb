module Fakturoid
  module Client
    class User < Api
      def self.current
        get_request('user.json', url: Fakturoid::Api.config.endpoint_without_account)
      end
      
      def self.find(id)
        validate_numerical_id(id)
        get_request("users/#{id}.json")
      end
      
      def self.all
        get_request("users.json")
      end
    end
  end
end