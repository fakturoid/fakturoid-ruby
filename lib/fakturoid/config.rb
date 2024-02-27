# frozen_string_literal: true

module Fakturoid
  class Config
    EXPIRY_BUFFER_IN_SECONDS = 10

    attr_accessor :email, :account, :client_id, :client_secret, :oauth_flow, :redirect_uri, :access_token_refresh_callback,
                  :refresh_token, :access_token, :expires_at, :access_token_type
    attr_writer :user_agent

    SUPPORTED_FLOWS = %w[authorization_code client_credentials].freeze
    API_ENDPOINT = "https://app.fakturoid.cz/api/v3"
    # API_ENDPOINT = "http://app.fakturoid.localhost/api/v3" # For development purposes
    OAUTH_ENDPOINT = "#{API_ENDPOINT}/oauth".freeze

    def initialize
      yield self

      validate_configuration
    end

    def user_agent
      if Utils.empty?(@user_agent)
        "Fakturoid ruby gem (#{email})"
      else
        "Fakturoid ruby gem - #{@user_agent}"
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
      "#{access_token_type} #{access_token}"
    end

    def authorization_code_flow?
      oauth_flow == "authorization_code"
    end

    def client_credentials_flow?
      oauth_flow == "client_credentials"
    end

    # TODO: This should be able to accept a hash. It's not ideal to store the access_token_type, the service should know it automatically.
    def update_oauth_tokens(tokens)
      self.refresh_token = tokens.refresh_token unless Utils.empty?(tokens.refresh_token)
      self.access_token = tokens.access_token
      self.access_token_type = tokens.token_type
      self.expires_at =
        if tokens.respond_to?(:expires_at)
          # TODO: Make this less ugly.
          if tokens.expires_at.is_a?(String)
            DateTime.parse(tokens.expires_at)
          else
            tokens.expires_at
          end
        else
          prepare_expiry_time(tokens.expires_in)
        end
      self.access_token_type ||= tokens.access_token_type
    end

    def access_token_near_expiration?
      DateTime.now > expires_at
    end

    def credentials
      {
        access_token: access_token,
        refresh_token: refresh_token,
        expires_at: expires_at,
        access_token_type: access_token_type
      }
    end

    def duplicate(local_config)
      self.class.new do |c|
        c.email         = email
        c.account       = local_config[:account] || account
        c.user_agent    = user_agent
        c.client_id     = client_id
        c.client_secret = client_secret
        c.oauth_flow    = oauth_flow # 'client_credentials', 'authorization_code'
        # only authorization_code
        c.refresh_token = local_config[:refresh_token] || refresh_token
        c.access_token  = local_config[:access_token] || access_token
        c.redirect_uri  = redirect_uri
      end
    end

  private

    def validate_configuration
      raise ConfigurationError, "Missing or unsupported OAuth flow, supported flows are - `authorization_code`, `client_credentials`" unless SUPPORTED_FLOWS.include?(oauth_flow)
      raise ConfigurationError, "`email` or `user` agent is required" if Utils.empty?(email) && Utils.empty?(user_agent)
      raise ConfigurationError, "Client credentials are required" if Utils.empty?(client_id) || Utils.empty?(client_secret)
      raise ConfigurationError, "`redirect_uri` is required for Authorization Code Flow" if authorization_code_flow? && Utils.empty?(redirect_uri)
    end

    def prepare_expiry_time(expires_in)
      time = Time.now + (expires_in - EXPIRY_BUFFER_IN_SECONDS)
      time.to_datetime # DateTime serializes into is8601, Time doesn't, so it can be saved as JSON safely.
    end
  end
end
