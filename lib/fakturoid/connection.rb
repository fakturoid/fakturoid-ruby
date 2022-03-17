# frozen_string_literal: true

module Fakturoid
  module Connection
    DEFAULT_CONTENT_TYPE = "application/json"

    def default_options(options = {})
      {
        headers: {
          content_type: options.dig(:headers, :content_type) || DEFAULT_CONTENT_TYPE,
          user_agent: Fakturoid::Api.config.user_agent
        },
        url: options[:url] || Fakturoid::Api.config.endpoint
      }
    end

    def connection(options = {})
      @connection = Faraday.new default_options(options)

      # https://lostisland.github.io/faraday/middleware/authentication
      if Fakturoid::Api.config.faraday_v1?
        @connection.request :basic_auth, Fakturoid::Api.config.email, Fakturoid::Api.config.api_key
      else
        @connection.request :authorization, :basic, Fakturoid::Api.config.email, Fakturoid::Api.config.api_key
      end

      @connection
    end
  end
end
