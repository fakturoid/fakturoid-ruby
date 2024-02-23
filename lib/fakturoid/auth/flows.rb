# frozen_string_literal: true

module Fakturoid
  class Auth
    module Flows
      EXPIRY_BUFFER_IN_SECONDS = 10

      def request_client_credentials
        response = Api.post_request(
          "oauth/token",
          url: Api.config.endpoint_without_account,
          auth_with_client_id_and_secret: true,
          payload: {
            grant_type: "client_credentials"
          }
        )

        self.credentials = Credentials.new(
          access_token: response.body.fetch("access_token"),
          refresh_token: response.body["refresh_token"],
          expires_at: prepare_expiry_time(response.body.fetch("expires_in"))
        )
      end

      def request_credentials(code:)
        response = Api.post_request(
          "oauth/token",
          url: Api.config.endpoint_without_account,
          auth_with_client_id_and_secret: true,
          payload: {
            grant_type: "authorization_code",
            code: code,
            redirect_uri: Api.config.redirect_uri
          }
        )

        self.credentials = Credentials.new(
          access_token: response.body.fetch("access_token"),
          refresh_token: response.body["refresh_token"],
          expires_at: prepare_expiry_time(response.body.fetch("expires_in"))
        )
      end

      def refresh_access_token?
        credentials&.near_expiration?
      end

      def refresh_access_token
        if credentials.supports_refresh?
          refresh_authorization_code_flow_access_token
        else
          request_client_credentials
        end

        access_token_refresh_callback&.call(credentials)
      end

      def revoke_access
        Api.post_request(
          "oauth/revoke",
          url: Api.config.endpoint_without_account,
          auth_with_client_id_and_secret: true,
          payload: {
            token: credentials.refresh_token
          }
        )

        self.credentials = nil
      end

    private

      def prepare_expiry_time(expires_in)
        time = Time.now + (expires_in - EXPIRY_BUFFER_IN_SECONDS)
        time.to_datetime # DateTime serializes into is8601, Time doesn't, so it can be saved as JSON safely.
      end

      def refresh_authorization_code_flow_access_token
        response = Api.post_request(
          "oauth/token",
          url: Api.config.endpoint_without_account,
          auth_with_client_id_and_secret: true,
          payload: {
            grant_type: "refresh_token",
            refresh_token: credentials.refresh_token
          }
        )

        self.credentials = Credentials.new(
          access_token: response.body.fetch("access_token"),
          refresh_token: credentials.refresh_token,
          expires_at: prepare_expiry_time(response.body.fetch("expires_in"))
        )
      end
    end
  end
end
