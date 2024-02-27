# frozen_string_literal: true

module Fakturoid
  class Client
    include Api

    attr_reader :config

    def self.configure(&block)
      @config ||= Fakturoid::Config.new(&block) # rubocop:disable  Naming/MemoizedInstanceVariableName
    end

    def self.config
      @config
    end

    def initialize(config = {})
      raise ConfigurationError, "Configuration is missing" if self.class.config.nil?

      @config = self.class.config.duplicate(config)
    end

    def account=(account)
      config.account = account
    end

    def on_access_token_refresh(&block)
      config.access_token_refresh_callback = block
    end

    def call_access_token_refresh_callback
      config.access_token_refresh_callback&.call(config.credentials)
    end

    # Authorization methods

    def authorization_uri(state: nil)
      oauth.authorization_uri(state: state)
    end

    def authorize(code:)
      oauth.authorize(code: code)
    end

    def revoke_access
      oauth.revoke_access
    end

    def perform_request(method, path, params)
      oauth.perform_request(method, path, params)
    end

  private

    def oauth
      @oauth ||= Oauth.new(self)
    end
  end
end
