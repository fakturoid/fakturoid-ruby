# frozen_string_literal: true

module Fakturoid
  module Api
    class Generator
      include Common::Base

      def all(params = {})
        request_params = Utils.permit_params(params, :page, :since, :updated_since, :subject_id) || {}

        perform_request(HTTP_GET, "generators.json", request_params: request_params)
      end

      def recurring(params = {})
        request_params = Utils.permit_params(params, :page, :since, :updated_since, :subject_id) || {}

        perform_request(HTTP_GET, "generators/recurring.json", request_params: request_params)
      end

      def template(params = {})
        request_params = Utils.permit_params(params, :page, :since, :updated_since, :subject_id) || {}

        perform_request(HTTP_GET, "generators/template.json", request_params: request_params)
      end

      def find(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_GET, "generators/#{id}.json")
      end

      def create(payload = {})
        perform_request(HTTP_POST, "generators.json", payload: payload)
      end

      def update(id, payload = {})
        Utils.validate_numerical_id(id)
        perform_request(HTTP_PATCH, "generators/#{id}.json", payload: payload)
      end

      def delete(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_DELETE, "generators/#{id}.json")
      end
    end
  end
end
