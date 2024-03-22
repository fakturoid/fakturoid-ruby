# frozen_string_literal: true

module Fakturoid
  module Api
    class InventoryItem
      include Base

      INDEX_PARAMS = [:since, :until, :updated_since, :updated_until, :page, :article_number, :sku].freeze

      def all(params = {})
        request_params = Utils.permit_params(params, *INDEX_PARAMS) || {}

        perform_request(HTTP_GET, "inventory_items.json", request_params: request_params)
      end

      def archived(params = {})
        request_params = Utils.permit_params(params, *INDEX_PARAMS) || {}

        perform_request(HTTP_GET, "inventory_items/archived.json", request_params: request_params)
      end

      def low_quantity(params = {})
        request_params = Utils.permit_params(params, *INDEX_PARAMS) || {}

        perform_request(HTTP_GET, "inventory_items/low_quantity.json", request_params: request_params)
      end

      def search(params = {})
        Utils.validate_search_query(query: params[:query])

        request_params = Utils.permit_params(params, :query, :page)

        perform_request(HTTP_GET, "inventory_items/search.json", request_params: request_params)
      end

      def find(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_GET, "inventory_items/#{id}.json")
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

      def archive(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_POST, "inventory_items/#{id}/archive.json")
      end

      def unarchive(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_POST, "inventory_items/#{id}/unarchive.json")
      end
    end
  end
end
