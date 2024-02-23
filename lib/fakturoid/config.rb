# frozen_string_literal: true

module Fakturoid
  class Config
    attr_accessor :email, :client_id, :client_secret, :account, :redirect_uri, :credentials
    attr_writer :user_agent

    ENDPOINT = "https://app.fakturoid.cz/api/v3"
    # ENDPOINT = "http://app.fakturoid.localhost/api/v3"

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

    def account_present?
      !account.nil? && !account.empty?
    end

  private

    def major_faraday_version
      @major_faraday_version ||= Faraday::VERSION.split(".").first
    end
  end
end
