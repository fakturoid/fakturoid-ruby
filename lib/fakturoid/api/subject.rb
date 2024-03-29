# frozen_string_literal: true

module Fakturoid
  module Api
    class Subject
      include Base

      def all(params = {})
        request_params = Utils.permit_params(params, :since, :updated_since, :page, :custom_id) || {}

        perform_request(HTTP_GET, "subjects.json", request_params: request_params)
      end

      def search(params = {})
        Utils.validate_search_query(query: params[:query])

        request_params = Utils.permit_params(params, :query, :page)

        perform_request(HTTP_GET, "subjects/search.json", request_params: request_params)
      end

      def find(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_GET, "subjects/#{id}.json")
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
