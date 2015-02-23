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
    attr_accessor :response_code, :response_body
    
    def initialize(message = nil, response_code = nil, response_body = nil)
      super(message)
      self.response_code = response_code
      self.response_body = response_body
    end
  end
  
  class ContentTypeError        < ApiError; end
  class UserAgentError          < ApiError; end
  class AuthenticationError     < ApiError; end
  class BlockedAccountError     < ApiError; end
  class RateLimitError          < ApiError; end

  class RecordNotFoundError     < ApiError; end
  class InvalidRecordError      < ApiError; end
  class DestroySubjectError     < ApiError; end
  class SubjectLimitError       < ApiError; end
  class GeneratorLimitError     < ApiError; end
  class UnsupportedFeatureError < ApiError; end
  
  def self.configure(&block)
    Fakturoid::Api.configure(&block)
  end
end
