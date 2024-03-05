# frozen_string_literal: true

require_relative "oauth/credentials"
require_relative "oauth/flow"
require_relative "oauth/request"
require_relative "oauth/token_response"
require_relative "oauth/access_token_service"

module Fakturoid
  class Oauth
    extend Forwardable

    attr_reader :client, :flow, :access_token_service

    def_delegators :@flow, :authorization_uri, :authorize, :fetch_access_token, :revoke_access, :authorized?

    def initialize(client)
      @client = client
      @flow = find_flow
      @access_token_service = AccessTokenService.new(self)
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
