module Fakturoid
  class Response
    attr_reader :response, :caller, :env, :body
    
    def initialize(faraday_response, caller)
      @response = faraday_response
      @caller = caller
      @env = faraday_response.env

      @body = MultiJson.load(env.body) if !(env.body.nil? || env.body.empty? || env.body =~ /\A\s+\z/)
      handle_response
    end
    
    def method_missing(method, *args, &block)
      if body && body.key?(method.to_s)
        body[method.to_s]
      else
        super
      end
    end
    
    def status_code
      env['status']
    end
    
    def inspect
      "#<#{self.class.name}:#{object_id} @body=\"#{self.body}\" @status_code=\"#{status_code}\">"
    end
  
  private
  
    def handle_response
      case status_code
        when 401 then raise error(AuthenticationError, "Authentification failed")
        when 402 then raise error(BlockedAccountError, "Account is blocked")
        when 404 then raise error(ReadOnlyUserError, "User is read only")
      end
    end
    
    def error(klass, message = nil)
      klass.new message, status_code, body
    end
  end
end