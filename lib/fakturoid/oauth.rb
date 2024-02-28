# frozen_string_literal: true

require_relative "oauth/credentials"
require_relative "oauth/flow"
require_relative "oauth/request"
require_relative "oauth/token_response"
require_relative "oauth/access_token_service"

module Fakturoid
  class Oauth
    attr_reader :client, :flow, :access_token_service

    def initialize(client)
      @client = client
      @flow = find_flow
      @access_token_service = AccessTokenService.new(self)
    end

    def authorization_uri(state: nil)
      flow.authorization_uri(state: state)
    end

    def authorize(code:)
      flow.authorize(code: code)
    end

    def fetch_access_token
      flow.fetch_access_token
    end

    def revoke_access
      flow.revoke_access
    end

    def authorized?
      flow.authorized?
    end

    def perform_request(method, path, params)
      access_token_service.perform_request(method, path, params)
    end

  private

    def find_flow
      if client.config.client_credentials_flow?
        Flow::ClientCredentials.new(client)
      elsif client.config.authorization_code_flow?
        Flow::AuthorizationCode.new(client)
      else
        raise ConfigurationError, "Unsupported OAuth flow."
      end
    end
  end
end
