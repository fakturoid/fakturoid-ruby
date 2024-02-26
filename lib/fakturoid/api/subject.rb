# frozen_string_literal: true

module Fakturoid
  module Api
    class Subject
      include Common::Base

      def all(params = {})
        request_params = Utils.permit_params(params, :page, :since, :updated_since, :custom_id) || {}

        perform_request(HTTP_GET, "subjects.json", request_params: request_params)
      end

      def find(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_GET, "subjects/#{id}.json")
      end

      def search(query, params = {})
        validate_search_query(query)

        request_params = Utils.permit_params(params, :page)
        request_params[:query] = query

        perform_request(HTTP_GET, "subjects/search.json", request_params: request_params)
      end

      def create(payload = {})
        perform_request(HTTP_POST, "subjects.json", payload: payload)
      end

      def update(id, payload = {})
        Utils.validate_numerical_id(id)
        perform_request(HTTP_PATCH, "subjects/#{id}.json", payload: payload)
      end

      def delete(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_DELETE, "subjects/#{id}.json")
      end
    end
  end
end
