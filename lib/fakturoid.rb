# frozen_string_literal: true

require "uri"
require "multi_json"
require "faraday"

require_relative "fakturoid/utils"
require_relative "fakturoid/config"
require_relative "fakturoid/response"
require_relative "fakturoid/api"
require_relative "fakturoid/oauth"
require_relative "fakturoid/client"
require_relative "fakturoid/version"
require_relative "fakturoid/railtie" if defined?(::Rails)

module Fakturoid
  class ApiError < StandardError
    attr_accessor :response_code, :response_body

    def initialize(message = nil, response_code = nil, response_body = nil)
      super(message)
      self.response_code = response_code
      self.response_body = response_body
    end
  end

  class ConfigurationError      < ApiError; end
  class OauthError              < ApiError; end
  class AuthenticationError     < ApiError; end

  class ClientError < ApiError; end
  class ServerError < ApiError; end

  HTTP_GET    = :get
  HTTP_POST   = :post
  HTTP_PATCH  = :patch
  HTTP_DELETE = :delete

  def self.configure(&block)
    Client.configure(&block)
  end

  def self.client
    @client ||= Client.new
  end
end
