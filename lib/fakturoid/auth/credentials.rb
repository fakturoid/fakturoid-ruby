# frozen_string_literal: true

module Fakturoid
  class Auth
    class Credentials
      attr_accessor :access_token, :expires_at, :refresh_token

      def initialize(values = {})
        values = values.transform_keys(&:to_sym)
        expires_at = values[:expires_at]
        expires_at = DateTime.parse(expires_at) if expires_at.is_a?(String)

        self.access_token  = values[:access_token]
        self.expires_at    = expires_at
        self.refresh_token = values[:refresh_token]
      end

      def near_expiration?
        DateTime.now > expires_at
      end

      def supports_refresh?
        refresh_token && !refresh_token.empty?
      end

      def as_json
        {
          access_token: access_token,
          refresh_token: refresh_token,
          expires_at: expires_at
        }
      end
    end
  end
end
