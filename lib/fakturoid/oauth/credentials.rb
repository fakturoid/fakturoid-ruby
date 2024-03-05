# frozen_string_literal: true

module Fakturoid
  class Oauth
    class Credentials
      EXPIRY_BUFFER_IN_SECONDS = 10
      MAX_EXPIRY_IN_SECONDS    = 2 * 3600 # 2 hours

      attr_accessor :access_token, :refresh_token, :token_type
      attr_reader :expires_at

      def initialize(values = {})
        update(values)
      end

      def update(values)
        values = values.transform_keys(&:to_sym)

        self.access_token  = values[:access_token]
        self.refresh_token = values[:refresh_token] unless Utils.empty?(values[:refresh_token])
        self.expires_at    = values[:expires_at] || values[:expires_in]
        self.token_type  ||= values[:token_type]
      end

      def expires_at=(value)
        @expires_at = parse_expires_at(value)
      end

      def expires_in=(value)
        self.expires_at = value
      end

      def access_token_expired?
        Time.now > (expires_at - EXPIRY_BUFFER_IN_SECONDS)
      end

      def as_json
        {
          access_token: access_token,
          refresh_token: refresh_token,
          expires_at: expires_at.to_datetime, # `DateTime` serializes into is8601, `Time` doesn't, so it can be saved as JSON safely.
          token_type: token_type
        }
      end

    private

      def parse_expires_at(value)
        case value
          when DateTime
            value.to_time
          when String
            Time.parse(value)
          when Integer # `value` in seconds
            raise ArgumentError, "`expires_at` cannot be unix timestamp (was #{value.inspect})" if value > MAX_EXPIRY_IN_SECONDS
            Time.now + value
          else
            value
        end
      end
    end
  end
end
