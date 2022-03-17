# frozen_string_literal: true

module Fakturoid
  module Client
    class Account < Fakturoid::Api
      def self.current
        get_request("account.json")
      end
    end
  end
end
