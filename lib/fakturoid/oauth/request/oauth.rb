# frozen_string_literal: true

module Fakturoid
  class Oauth
    module Request
      class Oauth
        include Base

      protected

        def connection(options = {})
          Faraday.new default_options(options) do |conn|
            conn.set_basic_auth(client.config.client_id, client.config.client_secret)
            conn.adapter Faraday.default_adapter
          end
        end

        def endpoint
          client.config.oauth_endpoint
        end
      end
    end
  end
end
