# frozen_string_literal: true

module Fakturoid
  module Connection
    def default_options(options = {})
      content_type = options[:headers] && options[:headers][:content_type]
      {
        headers: {
          content_type: content_type || "application/json",
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
