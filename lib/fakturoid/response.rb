module Fakturoid
  class Response
    attr_reader :response, :caller, :env, :body, :request_method
    
    def initialize(faraday_response, caller, request_method)
      @response = faraday_response
      @caller = caller
      @env = faraday_response.env
      @request_method = request_method.to_sym
      
      if !(env.body.nil? || env.body.empty? || (json? && env.body =~ /\A\s+\z/))
        @body = json? ? MultiJson.load(env.body) : env.body
      end
      handle_response
    end
    
    def status_code
      env['status']
    end
    
    def json?
      env.request_headers['Content-Type'] == 'application/json'
    end
    
    def headers
      env.response_headers
    end
    
    def inspect
      "#<#{self.class.name}:#{object_id} @body=\"#{self.body}\" @status_code=\"#{status_code}\">"
    end
  
  private
  
    def handle_response
      case status_code
        when 400 
          raise error(UserAgentError,  'User-Agent header missing') if env.request_headers['User-Agent'].nil? || env.request_headers['User-Agent'].empty?
          raise error(PaginationError, 'Page does not exist')
        when 401 then raise error(AuthenticationError, 'Authentification failed')
        when 402 then raise error(BlockedAccountError, 'Account is blocked')
        when 403 then 
          raise error(DestroySubjectError, 'Cannot destroy subject with invoices')          if caller == Client::Subject && request_method == :delete
          raise error(SubjectLimitError,   'Subject limit for account reached')             if caller == Client::Subject && request_method == :post
          raise error(GeneratorLimitError, 'Recurring generator limit for account reached') if caller == Client::Generator
          raise error(UnsupportedFeatureError, 'Feature unavailable for account plan')
        when 404 then raise error(RecordNotFoundError, 'Record not found')
        when 415 then raise error(ContentTypeError,    'Unsupported Content-Type')
        when 422 then raise error(InvalidRecordError,  'Invalid record')
        when 429 then raise error(RateLimitError,      'Rate limit reached')
        when 503 then raise error(ReadOnlySiteError,   'Fakturoid is in read only state')
        else
          raise error(ServerError, 'Server error') if status_code >= 500
          raise error(ClientError, 'Client error') if status_code >= 400
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
      body && body.is_a?(Hash) && body.key?(key.to_s)
    end
  end
end
