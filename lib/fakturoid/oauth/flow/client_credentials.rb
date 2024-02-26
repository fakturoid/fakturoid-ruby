# frozen_string_literal: true

module Fakturoid
  class Oauth
    module Flow
      class ClientCredentials
        include Base

        GRANT_TYPE = "client_credentials"

        def fetch_access_token
          payload = {
            grant_type: GRANT_TYPE
          }

          response = perform_request(HTTP_POST, "token.json", payload: payload)
          client.config.update_oauth_tokens(response)
          response
        end

        def authorized?
          true
        end
      end
    end
  end
end
