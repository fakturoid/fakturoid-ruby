# frozen_string_literal: true

module Fakturoid
  class Oauth
    module Flow
      module Base
        attr_reader :client

        def initialize(client)
          @client = client
        end

        def authorization_uri(state: nil)
          raise NotImplementedError, "Authorization path is not supported"
        end

        def authorize(code:)
          raise NotImplementedError, "Authorize is not supported"
        end

        def fetch_access_token
          raise NotImplementedError, "Get access token is not supported"
        end

        def revoke_access
          raise NotImplementedError, "Revoke access is not supported"
        end

        def authorized?
          raise NotImplementedError, "Authorized is not supported"
        end

      protected

        def perform_request(method, path, params)
          raw_response = Request::Oauth.new(method, path, client).call(params)
          TokenResponse.new(raw_response)
        end
      end
    end
  end
end
