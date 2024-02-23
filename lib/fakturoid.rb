# frozen_string_literal: true

require "uri"
require "multi_json"
require "faraday"

require "fakturoid/config"
require "fakturoid/connection"
require "fakturoid/auth"
require "fakturoid/request"
require "fakturoid/response"
require "fakturoid/api"
require "fakturoid/client"
require "fakturoid/version"
require "fakturoid/railtie" if defined?(::Rails)

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
  class ReadOnlySiteError       < ApiError; end
  class PaginationError         < ApiError; end

  class RecordNotFoundError     < ApiError; end
  class InvalidRecordError      < ApiError; end
  class DestroySubjectError     < ApiError; end
  class SubjectLimitError       < ApiError; end
  class GeneratorLimitError     < ApiError; end
  class UnsupportedFeatureError < ApiError; end

  class ClientError < ApiError; end
  class ServerError < ApiError; end

  def self.configure(&block)
    Api.configure(&block)
  end

  def self.account=(account)
    Api.config.account = account
  end

  def self.auth
    @auth ||= Auth.new
  end
end
