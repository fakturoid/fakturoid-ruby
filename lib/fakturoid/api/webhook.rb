# frozen_string_literal: true

module Fakturoid
  module Api
    class Webhook
      include Base

      def all(params = {})
        request_params = Utils.permit_params(params, :page)

        perform_request(HTTP_GET, "webhooks.json", request_params: request_params)
      end

      def find(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_GET, "webhooks/#{id}.json")
      end

      def create(payload = {})
        perform_request(HTTP_POST, "webhooks.json", payload: payload)
      end

      def update(id, payload = {})
        Utils.validate_numerical_id(id)
        perform_request(HTTP_PATCH, "webhooks/#{id}.json", payload: payload)
      end

      def delete(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_DELETE, "webhooks/#{id}.json")
      end
    end
  end
end
