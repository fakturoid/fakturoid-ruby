# frozen_string_literal: true

module Fakturoid
  class Oauth
    module Flow
      class AuthorizationCode
        include Base

        GRANT_TYPE = "authorization_code"

        def authorization_uri(state: nil)
          client.config.authorization_uri(state: state)
        end

        def authorize(code:)
          payload = {
            grant_type: GRANT_TYPE,
            redirect_uri: client.config.redirect_uri,
            code: code
          }

          response = perform_request(HTTP_POST, "token.json", payload: payload)
          client.config.update_oauth_tokens(response)
          response
        end

        def fetch_access_token
          payload = {
            grant_type: "refresh_token",
            refresh_token: client.config.refresh_token
          }

          response = perform_request(HTTP_POST, "token.json", payload: payload)
          client.config.update_oauth_tokens(response)
          response
        end

        def revoke_access
          payload = {
            refresh_token: client.config.refresh_token
          }

          perform_request(HTTP_POST, "revoke.json", payload: payload)
        end

        def authorized?
          !Utils.empty?(client.config.refresh_token)
        end
      end
    end
  end
end
