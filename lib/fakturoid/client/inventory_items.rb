# frozen_string_literal: true

module Fakturoid
  module Client
    class InventoryItems < Fakturoid::Api
      INDEX_PARAMS = [:page, :since, :updated_since, :article_number, :sku].freeze

      def self.all(params = {})
        request_params = permit_params(params, *INDEX_PARAMS) || {}

        get_request("inventory_items.json", request_params: request_params)
      end

      def self.archived(params = {})
        request_params = permit_params(params, *INDEX_PARAMS) || {}

        get_request("inventory_items/archived.json", request_params: request_params)
      end

      def self.find(id)
        validate_numerical_id(id)
        get_request("inventory_items/#{id}.json")
      end

      def self.search(query, params = {})
        validate_search_query(query)

        request_params = permit_params(params, :page)
        request_params[:query] = query

        get_request("inventory_items/search.json", request_params: request_params)
      end

      def self.archive(id)
        validate_numerical_id(id)
        patch_request("inventory_items/#{id}/archive.json")
      end

      def self.unarchive(id)
        validate_numerical_id(id)
        patch_request("inventory_items/#{id}/unarchive.json")
      end

      def self.create(payload = {})
        post_request("inventory_items.json", payload: payload)
      end

      def self.update(id, payload = {})
        validate_numerical_id(id)
        patch_request("inventory_items/#{id}.json", payload: payload)
      end

      def self.delete(id)
        validate_numerical_id(id)
        delete_request("inventory_items/#{id}.json")
      end
    end
  end
end
