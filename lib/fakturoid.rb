require 'uri'
require 'multi_json'
require 'faraday'

require 'fakturoid/config'
require 'fakturoid/connection'
require 'fakturoid/request'
require 'fakturoid/response'
require 'fakturoid/api'
require 'fakturoid/client'
require 'fakturoid/version'
require 'fakturoid/railtie' if defined?(::Rails)

module Fakturoid
  
  class ApiError < StandardError
    attr_accessor :response_code, :full_response
    
    def initialize(message = nil, response_code = nil, full_response = nil)
      super(message)
      self.response_code = response_code
      self.full_response = full_response
    end
  end
  
  class AuthenticationError < ApiError; end
  class RecordNotFoundError < ApiError; end
  class BlockedAccountError < ApiError; end 
  
  def self.configure(&block)
    Fakturoid::Api.configure(&block)
  end
end
