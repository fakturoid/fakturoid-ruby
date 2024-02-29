# frozen_string_literal: true

module Fakturoid
  class Response
    attr_reader :response, :caller, :body, :request_method

    def initialize(faraday_response, caller, request_method)
      @response = faraday_response
      @caller = caller
      @request_method = request_method.to_sym

      env = response.env

      if !(env.body.nil? || env.body.empty? || (json? && env.body =~ /\A\s+\z/))
        @body = json? ? MultiJson.load(env.body) : env.body
      end

      handle_response
    end

    def status_code
      response.env["status"]
    end

    def json?
      headers["content-type"] =~ %r{\Aapplication/json}
    end

    def headers
      response.env.response_headers.transform_keys(&:downcase)
    end

    def inspect
      "#<#{self.class.name}:#{object_id} @body=\"#{body}\" @status_code=\"#{status_code}\">"
    end

  private

    def handle_response
      case status_code
        when 401 then raise error(AuthenticationError, "Authentication failed")
        else
          raise error(ServerError, "Server error") if status_code >= 500
          raise error(ClientError, "Client error") if status_code >= 400
      end
    end

    def error(klass, message = nil)
      klass.new message, status_code, body
    end

    def method_missing(method, *args, &block)
      if body_has_key?(method)
        body[method.to_s]
      else
        super
      end
    end

    def respond_to_missing?(method, _include_all)
      body_has_key?(method) || super
    end

    def body_has_key?(key)
      body.is_a?(Hash) && body.key?(key.to_s)
    end
  end
end
