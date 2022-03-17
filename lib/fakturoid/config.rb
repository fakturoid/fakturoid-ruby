# frozen_string_literal: true

module Fakturoid
  class Config
    attr_accessor :email, :api_key, :account
    attr_writer :user_agent

    ENDPOINT = "https://app.fakturoid.cz/api/v2"

    def initialize(&_block)
      yield self
    end

    def user_agent
      if !defined?(@user_agent) || @user_agent.nil? || @user_agent.empty?
        "Fakturoid ruby gem (#{email})"
      else
        @user_agent
      end
    end

    def endpoint
      "#{ENDPOINT}/accounts/#{account}"
    end

    def endpoint_without_account
      ENDPOINT
    end

    def faraday_v1?
      major_faraday_version == "1"
    end

  private

    def major_faraday_version
      @major_faraday_version ||= Faraday::VERSION.split(".").first
    end
  end
end
