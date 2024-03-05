# frozen_string_literal: true

module Fakturoid
  class Client
    extend Forwardable
    include Api

    attr_reader :config

    # Authorization methods
    def_delegators :@oauth, :authorization_uri, :authorize, :revoke_access, :perform_request

    def self.configure(&block)
      @config ||= Fakturoid::Config.new(&block) # rubocop:disable  Naming/MemoizedInstanceVariableName
    end

    def self.config
      @config
    end

    def initialize(config = {})
      raise ConfigurationError, "Configuration is missing" if self.class.config.nil?

      @config = self.class.config.duplicate(config)
      @oauth  = Oauth.new(self)
    end

    def account=(account)
      config.account = account
    end

    def credentials
      config.credentials
    end

    def credentials=(values)
      config.credentials = values
    end

    def on_access_token_refresh(&block)
      config.access_token_refresh_callback = block
    end

    def call_access_token_refresh_callback
      config.access_token_refresh_callback&.call(config.credentials)
    end
  end
end
