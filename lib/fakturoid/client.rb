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

    def credentials_updated_callback(&block)
      config.credentials_updated_callback = block
    end

    def call_credentials_updated_callback
      config.credentials_updated_callback&.call(config.credentials)
    end
  end
end
