# frozen_string_literal: true

module Fakturoid
  module Api
    class Expense
      include Common::Base

      def all(params = {})
        request_params = Utils.permit_params(params, :page, :since, :updated_since, :number, :variable_symbol, :status, :subject_id, :custom_id) || {}

        perform_request(HTTP_GET, "expenses.json", request_params: request_params)
      end

      def find(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_GET, "expenses/#{id}.json")
      end

      def search(query, params = {})
        Utils.validate_search_query(query)

        request_params = Utils.permit_params(params, :page)
        request_params[:query] = query

        perform_request(HTTP_GET, "expenses/search.json", request_params: request_params)
      end

      def fire(id, event, params = {})
        request_params = Utils.permit_params(params, :paid_on, :paid_amount, :variable_symbol, :bank_account_id) || {}
        request_params[:event] = event

        Utils.validate_numerical_id(id)
        perform_request(HTTP_POST, "expenses/#{id}/fire.json", request_params: request_params)
      end

      def create(payload = {})
        perform_request(HTTP_POST, "expenses.json", payload: payload)
      end

      def update(id, payload = {})
        Utils.validate_numerical_id(id)
        perform_request(HTTP_PATCH, "expenses/#{id}.json", payload: payload)
      end

      def delete(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_DELETE, "expenses/#{id}.json")
      end
    end
  end
end
