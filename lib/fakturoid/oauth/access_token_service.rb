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

        # TODO: Should it fetch if it's nil in case of first call via client credentials flow?
        fetch_access_token if Utils.empty?(client.config.access_token) || client.config.access_token_near_expiration?

        retried = false

        begin
          Request::Api.new(method, path, client).call(params).tap do
            client.call_access_token_refresh_callback
          end
        rescue AuthenticationError
          raise if retried
          retried = true
          fetch_access_token

          retry
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
