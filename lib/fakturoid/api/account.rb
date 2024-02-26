# frozen_string_literal: true

module Fakturoid
  module Api
    class Account
      include Common::Base

      def current
        perform_request(HTTP_GET, "account.json")
      end
    end
  end
end
