# frozen_string_literal: true

module Fakturoid
  class Oauth
    class Credentials
      EXPIRY_BUFFER_IN_SECONDS = 10

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
        @expires_at =
          if value.is_a?(String)
            DateTime.parse(value)
          elsif value.is_a?(Integer)
            prepare_expiry_time(value)
          else
            value
          end
      end

      def expires_in=(value)
        self.expires_at = value
      end

      def access_token_near_expiration?
        DateTime.now > expires_at
      end

      def as_json
        {
          access_token: access_token,
          refresh_token: refresh_token,
          expires_at: expires_at,
          token_type: token_type
        }
      end

    private

      def prepare_expiry_time(seconds)
        time = Time.now + (seconds - EXPIRY_BUFFER_IN_SECONDS)
        time.to_datetime # DateTime serializes into is8601, Time doesn't, so it can be saved as JSON safely.
      end
    end
  end
end
