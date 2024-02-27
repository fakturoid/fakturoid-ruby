# frozen_string_literal: true

module Fakturoid
  module Api
    class Invoice
      include Common::Base

      INDEX_PARAMS = [:page, :since, :until, :updated_since, :updated_until, :number, :status, :subject_id, :custom_id].freeze

      def all(params = {})
        request_params = Utils.permit_params(params, *INDEX_PARAMS) || {}

        perform_request(HTTP_GET, "invoices.json", request_params: request_params)
      end

      def regular(params = {})
        request_params = Utils.permit_params(params, *INDEX_PARAMS) || {}

        perform_request(HTTP_GET, "invoices/regular.json", request_params: request_params)
      end

      def proforma(params = {})
        request_params = Utils.permit_params(params, *INDEX_PARAMS) || {}

        perform_request(HTTP_GET, "invoices/proforma.json", request_params: request_params)
      end

      def find(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_GET, "invoices/#{id}.json")
      end

      def search(query, params = {})
        Utils.validate_search_query(query)

        request_params = Utils.permit_params(params, :page)
        request_params[:query] = query

        perform_request(HTTP_GET, "invoices/search.json", request_params: request_params)
      end

      def download_pdf(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_GET, "invoices/#{id}/download.pdf", headers: { content_type: "application/pdf" })
      end

      def fire(id, event, params = {})
        request_params = Utils.permit_params(params, :paid_at, :paid_amount, :variable_symbol, :bank_account_id) || {}
        request_params[:event] = event

        Utils.validate_numerical_id(id)
        perform_request(HTTP_POST, "invoices/#{id}/fire.json", request_params: request_params)
      end

      def deliver_message(invoice_id, payload = {})
        Utils.validate_numerical_id(invoice_id)
        perform_request(HTTP_POST, "invoices/#{invoice_id}/message.json", payload: payload)
      end

      def create(payload = {})
        perform_request(HTTP_POST, "invoices.json", payload: payload)
      end

      def update(id, payload = {})
        Utils.validate_numerical_id(id)
        perform_request(HTTP_PATCH, "invoices/#{id}.json", payload: payload)
      end

      def delete(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_DELETE, "invoices/#{id}.json")
      end
    end
  end
end
