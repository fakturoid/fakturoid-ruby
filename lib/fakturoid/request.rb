# frozen_string_literal: true

module Fakturoid
  class Request
    include Connection

    attr_reader :method, :path, :caller

    HTTP_METHODS = [:get, :post, :patch, :delete].freeze

    def initialize(method, path, caller)
      @method = method
      @path   = path
      @caller = caller
    end

    def call(params = {})
      raise ArgumentError, "Unknown http method: #{method}" unless HTTP_METHODS.include?(method.to_sym)
      raise ArgumentError, "Account slug is not set. You must set it before calling this method." if params[:url].nil? && !Api.config.account_present?

      request_params = params[:request_params] || {}

      Fakturoid.auth.refresh_access_token if !params[:auth_with_client_id_and_secret] && Fakturoid.auth.refresh_access_token?

      http_connection = connection(params)
      response = http_connection.send(method) do |req|
        req.url path, request_params
        req.body = MultiJson.dump(params[:payload]) if params.key?(:payload)
      end
      Response.new(response, caller, method)
    end
  end
end
