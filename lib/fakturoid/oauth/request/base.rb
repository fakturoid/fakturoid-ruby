# frozen_string_literal: true

module Fakturoid
  class Oauth
    module Request
      module Base
        attr_reader :method, :path, :client

        HTTP_METHODS = [:get, :post, :patch, :delete].freeze
        REQUEST_TIMEOUT = 10

        def initialize(method, path, client)
          @method = method
          @path   = path
          @client = client
        end

        def call(params = {})
          raise ArgumentError, "Unknown http method: #{method}" unless HTTP_METHODS.include?(method.to_sym)

          request_params = params[:request_params] || {}

          http_connection = connection(params)

          http_connection.send(method) do |req|
            req.url path, request_params
            req.body = MultiJson.dump(params[:payload]) if params.key?(:payload)
          end
        end

      protected

        def default_options(options = {})
          {
            headers: {
              content_type: "application/json",
              accept: "application/json",
              user_agent: client.config.user_agent
            },
            url: options[:url] || endpoint,
            request: {
              timeout: REQUEST_TIMEOUT
            }
          }
        end

        def endpoint
          client.config.api_endpoint
        end

        def connection(options = {})
          Faraday.new default_options(options) do |conn|
            conn.headers[:authorization] = client.config.access_token_auth_header
            conn.adapter Faraday.default_adapter
          end
        end
      end
    end
  end
end
