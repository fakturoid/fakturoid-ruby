# frozen_string_literal: true

module Fakturoid
  module Api
    class User
      include Base

      def current
        perform_request(HTTP_GET, "user.json", url: client.config.api_endpoint_without_account)
      end

      def all
        perform_request(HTTP_GET, "users.json")
      end
    end
  end
end
