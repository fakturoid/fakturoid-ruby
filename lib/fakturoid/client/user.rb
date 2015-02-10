module Fakturoid
  module Client
    class User < Api
      def self.current
        get_request('user.json', url: Fakturoid::Api.config.endpoint_without_account)
      end
      
      def self.find(id)
        raise ArgumentError, "ID has to be integer" unless id.is_a?(Integer)
        
        get_request("users/#{id}.json")
      end
      
      def self.all
        get_request("users.json")
      end
    end
  end
end