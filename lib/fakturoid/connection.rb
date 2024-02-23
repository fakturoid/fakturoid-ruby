# frozen_string_literal: true

module Fakturoid
  module Connection
    DEFAULT_CONTENT_TYPE = "application/json"
    DEFAULT_ACCEPT = "application/json"

    def default_options(options = {})
      {
        headers: {
          content_type: options.dig(:headers, :content_type) || DEFAULT_CONTENT_TYPE,
          accept: options.dig(:headers, :accept) || DEFAULT_ACCEPT,
          user_agent: Api.config.user_agent
        },
        url: options[:url] || Api.config.endpoint
      }
    end

    def connection(options = {})
      @connection = Faraday.new default_options(options)

      # https://lostisland.github.io/faraday/#/middleware/included/authentication
      if options[:auth_with_client_id_and_secret]
        if Api.config.faraday_v1?
          @connection.request :basic_auth, Api.config.client_id, Api.config.client_secret
        else
          @connection.request :authorization, :basic, Api.config.client_id, Api.config.client_secret
        end
      elsif Api.config.credentials
        @connection.request :authorization, "Bearer", Api.config.credentials.access_token
      else
        raise ArgumentError, 'OAuth "access_token" not set'
      end

      @connection
    end
  end
end
