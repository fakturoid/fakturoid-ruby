# frozen_string_literal: true

module Fakturoid
  module Api
    class Invoice
      include Common::Base

      INDEX_PARAMS = [:since, :until, :updated_since, :updated_until, :page, :subject_id, :custom_id, :number, :status, :document_type].freeze

      def all(params = {})
        request_params = Utils.permit_params(params, *INDEX_PARAMS) || {}

        perform_request(HTTP_GET, "invoices.json", request_params: request_params)
      end

      def search(params = {})
        Utils.validate_search_query(query: params[:query], tags: params[:tags], allow_tags: true)

        request_params = Utils.permit_params(params, :query, :tags, :page)

        perform_request(HTTP_GET, "invoices/search.json", request_params: request_params)
      end

      def find(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_GET, "invoices/#{id}.json")
      end

      def download_pdf(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_GET, "invoices/#{id}/download.pdf", headers: { content_type: "application/pdf" })
      end

      def download_attachment(invoice_id, id)
        Utils.validate_numerical_id(invoice_id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_GET, "invoices/#{invoice_id}/attachments/#{id}/download")
      end

      def fire(id, event)
        request_params = { event: event }

        Utils.validate_numerical_id(id)
        perform_request(HTTP_POST, "invoices/#{id}/fire.json", request_params: request_params)
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
