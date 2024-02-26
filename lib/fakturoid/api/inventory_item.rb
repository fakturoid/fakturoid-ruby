# frozen_string_literal: true

module Fakturoid
  module Api
    class InventoryItem
      include Common::Base

      INDEX_PARAMS = [:page, :since, :updated_since, :article_number, :sku].freeze

      def self.all(params = {})
        request_params = Utils.permit_params(params, *INDEX_PARAMS) || {}

        perform_request(HTTP_GET, "inventory_items.json", request_params: request_params)
      end

      def self.archived(params = {})
        request_params = Utils.permit_params(params, *INDEX_PARAMS) || {}

        perform_request(HTTP_GET, "inventory_items/archived.json", request_params: request_params)
      end

      def self.find(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_GET, "inventory_items/#{id}.json")
      end

      def self.search(query, params = {})
        validate_search_query(query)

        request_params = Utils.permit_params(params, :page)
        request_params[:query] = query

        perform_request(HTTP_GET, "inventory_items/search.json", request_params: request_params)
      end

      def self.archive(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_POST, "inventory_items/#{id}/archive.json")
      end

      def self.unarchive(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_POST, "inventory_items/#{id}/unarchive.json")
      end

      def self.create(payload = {})
        perform_request(HTTP_POST, "inventory_items.json", payload: payload)
      end

      def self.update(id, payload = {})
        Utils.validate_numerical_id(id)
        perform_request(HTTP_PATCH, "inventory_items/#{id}.json", payload: payload)
      end

      def self.delete(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_DELETE, "inventory_items/#{id}.json")
      end
    end
  end
end
