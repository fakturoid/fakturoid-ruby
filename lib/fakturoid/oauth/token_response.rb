# frozen_string_literal: true

module Fakturoid
  class Oauth
    class TokenResponse
      attr_reader :client, :response, :body

      def initialize(response)
        @response = response
        @body     = MultiJson.load(response.env.body) unless Utils.empty?(response.env.body)

        handle_response
      end

      def status_code
        response.env["status"]
      end

      def refresh_token
        body["refresh_token"]
      end

      def access_token
        body["access_token"]
      end

      def expires_in
        body["expires_in"]
      end

      def token_type
        body["token_type"]
      end

      def inspect
        "#<#{self.class.name}:#{object_id} @body=\"#{body}\" @status_code=\"#{status_code}\">"
      end

    private

      def handle_response
        case status_code
          when 400 then raise error(OauthError, "OAuth request failed")
          when 401 then raise error(AuthenticationError, "OAuth authentication failed")
          else
            raise error(ServerError, "Server error") if status_code >= 500
            raise error(ClientError, "Client error") if status_code >= 400
        end
      end

      def error(klass, message = nil)
        klass.new message, status_code, body
      end
    end
  end
end
