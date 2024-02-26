# frozen_string_literal: true

module Fakturoid
  module Api
    class InventoryMove
      include Common::Base

      def all(params = {})
        request_params = Utils.permit_params(params, :page, :since, :updated_since, :inventory_item_id) || {}

        perform_request(HTTP_GET, "inventory_moves.json", request_params: request_params)
      end

      def find(inventory_item_id, id)
        Utils.validate_numerical_id(inventory_item_id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_GET, "inventory_items/#{inventory_item_id}/inventory_moves/#{id}.json")
      end

      def create(inventory_item_id, payload = {})
        Utils.validate_numerical_id(inventory_item_id)
        perform_request(HTTP_POST, "inventory_items/#{inventory_item_id}/inventory_moves.json", payload: payload)
      end

      def update(inventory_item_id, id, payload = {})
        Utils.validate_numerical_id(inventory_item_id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_PATCH, "inventory_items/#{inventory_item_id}/inventory_moves/#{id}.json", payload: payload)
      end

      def delete(inventory_item_id, id)
        Utils.validate_numerical_id(inventory_item_id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_DELETE, "inventory_items/#{inventory_item_id}/inventory_moves/#{id}.json")
      end
    end
  end
end
