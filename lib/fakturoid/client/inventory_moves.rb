# frozen_string_literal: true

module Fakturoid
  module Client
    class InventoryMoves < Fakturoid::Api
      def self.all(inventory_item_id, params = {})
        request_params = permit_params(params, :page, :since, :updated_since, :inventory_item_id) || {}

        validate_numerical_id(inventory_item_id)
        get_request("/inventory_moves.json", request_params: request_params)
      end

      def self.find(inventory_item_id, id)
        validate_numerical_id(inventory_item_id)
        validate_numerical_id(id)
        get_request("inventory_items/#{inventory_item_id}/inventory_moves/#{id}.json")
      end

      def self.create(inventory_item_id, payload = {})
        validate_numerical_id(inventory_item_id)
        post_request("inventory_items/#{inventory_item_id}/inventory_moves.json", payload: payload)
      end

      def self.update(inventory_item_id, id, payload = {})
        validate_numerical_id(inventory_item_id)
        validate_numerical_id(id)
        patch_request("inventory_items/#{inventory_item_id}/inventory_moves.json", payload: payload)
      end

      def self.delete(inventory_item_id, id)
        validate_numerical_id(inventory_item_id)
        validate_numerical_id(id)
        delete_request("inventory_items/#{inventory_item_id}/inventory_moves/#{id}.json")
      end
    end
  end
end
