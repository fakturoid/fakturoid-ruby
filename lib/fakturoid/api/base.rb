# frozen_string_literal: true

module Fakturoid
  module Api
    module Base
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def perform_request(method, path, params = {})
        raw_response = client.perform_request(method, path, params)
        Response.new(raw_response, self.class, method)
      end
    end
  end
end
