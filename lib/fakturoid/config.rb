# frozen_string_literal: true

module Fakturoid
  class Config
    attr_accessor :email, :account, :client_id, :client_secret, :oauth_flow, :redirect_uri, :credentials_updated_callback
    attr_writer :user_agent

    SUPPORTED_FLOWS = %w[authorization_code client_credentials].freeze
    API_ENDPOINT = "https://app.fakturoid.cz/api/v3"
    # API_ENDPOINT = "http://app.fakturoid.localhost/api/v3" # For development purposes
    OAUTH_ENDPOINT = "#{API_ENDPOINT}/oauth".freeze

    def initialize
      yield self

      validate_configuration
    end

    def credentials
      @credentials ||= Oauth::Credentials.new
    end

    def credentials=(values)
      @credentials = values.is_a?(Hash) ? Oauth::Credentials.new(values) : values
    end

    def user_agent
      if Utils.empty?(@user_agent)
        "Fakturoid ruby gem (#{email})"
      else
        @user_agent
      end
    end

    def api_endpoint
      raise ConfigurationError, "Account slug is required" if Utils.empty?(account)

      "#{API_ENDPOINT}/accounts/#{account}"
    end

    def api_endpoint_without_account
      API_ENDPOINT
    end

    def oauth_endpoint
      OAUTH_ENDPOINT
    end

    def authorization_uri(state: nil)
      params = {
        client_id: client_id,
        redirect_uri: redirect_uri,
        response_type: "code"
      }
      params[:state] = state unless Utils.empty?(state)

      connection = Faraday::Connection.new(oauth_endpoint)
      connection.build_url(nil, params)
    end

    def access_token_auth_header
      "#{credentials.token_type} #{credentials.access_token}"
    end

    def authorization_code_flow?
      oauth_flow == "authorization_code"
    end

    def client_credentials_flow?
      oauth_flow == "client_credentials"
    end

    # We can create multiple instances of the client, make sure we isolate the config for each
    # as it contains credentials which must not be shared.
    def duplicate(new_config)
      self.class.new do |config|
        config.email         = email
        config.account       = new_config[:account] || account
        config.user_agent    = user_agent
        config.client_id     = client_id
        config.client_secret = client_secret
        config.oauth_flow    = oauth_flow # 'client_credentials', 'authorization_code'
        # only authorization_code
        config.redirect_uri  = redirect_uri
      end
    end

  private

    def validate_configuration
      raise ConfigurationError, "Missing or unsupported OAuth flow, supported flows are - `authorization_code`, `client_credentials`" unless SUPPORTED_FLOWS.include?(oauth_flow)
      raise ConfigurationError, "`email` or `user` agent is required" if Utils.empty?(email) && Utils.empty?(user_agent)
      raise ConfigurationError, "Client credentials are required" if Utils.empty?(client_id) || Utils.empty?(client_secret)
      raise ConfigurationError, "`redirect_uri` is required for Authorization Code Flow" if authorization_code_flow? && Utils.empty?(redirect_uri)
    end
  end
end
