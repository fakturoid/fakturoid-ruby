module Fakturoid
  class Response
    attr_reader :response, :caller, :env, :body, :request_method
    
    def initialize(faraday_response, caller, request_method)
      @response = faraday_response
      @caller = caller
      @env = faraday_response.env
      @request_method = request_method.to_sym
      
      if !(env.body.nil? || env.body.empty? || env.body =~ /\A\s+\z/)
        @body = json? ? MultiJson.load(env.body) : env.body
      end
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
    
    def json?
      env.request_headers['Content-Type'] == 'application/json'
    end
    
    def inspect
      "#<#{self.class.name}:#{object_id} @body=\"#{self.body}\" @status_code=\"#{status_code}\">"
    end
  
  private
  
    def handle_response
      case status_code
        when 400 
          raise error(UserAgentError, "User-Agent header missing") if env.request_headers['User-Agent'].nil? || env.request_headers['User-Agent'].empty?
        when 401 then raise error(AuthenticationError, "Authentification failed")
        when 402 then raise error(BlockedAccountError, "Account is blocked")
        when 403 then 
          raise error(DestroySubjectError, "Cannot destroy subject with invoices") if request_method == :delete
          raise error(SubjectLimitError,   "Subject limit for account reached")    if request_method == :post
        when 404 then raise error(RecordNotFoundError, "Record not found")
        when 415 then raise error(ContentTypeError,    "Unsupported Content-Type")
        when 422 then raise error(InvalidRecordError,  "Invalid record")
        when 429 then raise error(RateLimitError,      "Rate limit reached")
      end
    end
    
    def error(klass, message = nil)
      klass.new message, status_code, body
    end
  end
end