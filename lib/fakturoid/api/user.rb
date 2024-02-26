# frozen_string_literal: true

module Fakturoid
  module Api
    class User
      include Common::Base

      def current
        perform_request(HTTP_GET, "user.json", url: client.config.api_endpoint_without_account)
      end

      def find(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_GET, "users/#{id}.json")
      end

      def all
        perform_request(HTTP_GET, "users.json")
      end
    end
  end
end
