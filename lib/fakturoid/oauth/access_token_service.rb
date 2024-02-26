# frozen_string_literal: true

module Fakturoid
  class Oauth
    class AccessTokenService
      attr_reader :oauth, :client

      def initialize(oauth)
        @oauth  = oauth
        @client = oauth.client
      end

      def perform_request(method, path, params)
        check_access_token

        begin
          Request::Api.new(method, path, client).call(params)
        rescue AuthenticationError
          fetch_access_token
          Request::Api.new(method, path, client).call(params)
        end
      end

    private

      def check_access_token
        raise ArgumentError, "OAuth access was not authorized by user" unless oauth.authorized?
        return unless Utils.empty?(client.config.access_token)

        fetch_access_token
      end

      def fetch_access_token
        oauth.fetch_access_token
      end
    end
  end
end
