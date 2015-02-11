module Fakturoid
  class Request
    include Connection
    
    attr_reader :method, :path, :caller
    HTTP_METHODS = [:get, :post, :patch, :delete]
    
    def initialize(method, path, caller)
      @method = method
      @path   = path
      @caller = caller
    end
    
    def call(params = {})
      unless HTTP_METHODS.include?(method.to_sym)
        raise ArgumentError, "Unknown http method: #{method}"
      end
      request_params = params[:request_params] || {}
      
      http_connection = connection(params)
      response = http_connection.send(method) do |req|
        req.url path, request_params
        req.body = MultiJson.dump(params[:payload]) if params.key?(:payload)
      end
      Response.new(response, caller, method)
    end
  end
end