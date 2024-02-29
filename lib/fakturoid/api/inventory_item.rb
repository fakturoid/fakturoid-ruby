# frozen_string_literal: true

module Fakturoid
  module Api
    class InventoryItem
      include Common::Base

      INDEX_PARAMS = [:page, :since, :updated_since, :article_number, :sku].freeze

      def all(params = {})
        request_params = Utils.permit_params(params, *INDEX_PARAMS) || {}

        perform_request(HTTP_GET, "inventory_items.json", request_params: request_params)
      end

      def archived(params = {})
        request_params = Utils.permit_params(params, *INDEX_PARAMS) || {}

        perform_request(HTTP_GET, "inventory_items/archived.json", request_params: request_params)
      end

      def find(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_GET, "inventory_items/#{id}.json")
      end

      def search(query, params = {})
        Utils.validate_search_query(query: query)

        request_params = Utils.permit_params(params, :page)
        request_params[:query] = query

        perform_request(HTTP_GET, "inventory_items/search.json", request_params: request_params)
      end

      def archive(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_POST, "inventory_items/#{id}/archive.json")
      end

      def unarchive(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_POST, "inventory_items/#{id}/unarchive.json")
      end

      def create(payload = {})
        perform_request(HTTP_POST, "inventory_items.json", payload: payload)
      end

      def update(id, payload = {})
        Utils.validate_numerical_id(id)
        perform_request(HTTP_PATCH, "inventory_items/#{id}.json", payload: payload)
      end

      def delete(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_DELETE, "inventory_items/#{id}.json")
      end
    end
  end
end
