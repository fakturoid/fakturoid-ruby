# frozen_string_literal: true

require "fakturoid/auth/credentials"
require "fakturoid/auth/flows"

module Fakturoid
  class Auth
    include Flows

    attr_accessor :access_token_refresh_callback

    def credentials
      Api.config.credentials
    end

    def credentials=(credentials)
      credentials = Credentials.new(credentials) if credentials.is_a?(Hash)
      Api.config.credentials = credentials
    end

    def client_id
      Api.config.client_id
    end

    def client_secret
      Api.config.client_secret
    end

    def url(state: nil)
      connection = Faraday::Connection.new("#{Api.config.endpoint_without_account}/oauth")
      url = connection.build_url(
        nil,
        client_id: Api.config.client_id,
        redirect_uri: Api.config.redirect_uri,
        response_type: "code"
      )
      url = connection.build_url(url, state: state) if state && !state.empty?
      url
    end

    def on_access_token_refresh(&block)
      self.access_token_refresh_callback = block
    end
  end
end
