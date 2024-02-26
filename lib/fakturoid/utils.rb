# frozen_string_literal: true

module Fakturoid
  module Utils
    def self.permit_params(params_hash, *permitted_params)
      params_hash.select { |param, _value| permitted_params.include?(param.to_sym) }
    end

    def self.validate_numerical_id(id)
      raise ArgumentError, "Wrong ID given: #{id}" if !id.is_a?(Integer) && !(id.is_a?(String) && id =~ /\A\d+\z/)
      true
    end

    def self.validate_search_query(query)
      raise ArgumentError, "Query parameter is required" if query.nil? || query.empty?
      true
    end

    def self.empty?(string)
      string.nil? || string.empty?
    end
  end
end
