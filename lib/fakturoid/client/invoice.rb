module Fakturoid
  module Client
    class Invoice < Fakturoid::Api
      def self.all(params = {})
        request_params = permit_params(params, :page, :since, :updated_since, :number, :status, :subject_id) || {}

        get_request('invoices.json', request_params: request_params)
      end

      def self.regular(params = {})
        request_params = permit_params(params, :page, :since, :updated_since, :number, :status, :subject_id) || {}

        get_request('invoices/regular.json', request_params: request_params)
      end

      def self.proforma(params = {})
        request_params = permit_params(params, :page, :since, :updated_since, :number, :status, :subject_id) || {}

        get_request('invoices/proforma.json', request_params: request_params)
      end

      def self.find(id)
        validate_numerical_id(id)
        get_request("invoices/#{id}.json")
      end

      def self.search(query)
        validate_search_query(query)
        get_request('invoices/search.json', request_params: { query: query })
      end

      def self.download_pdf(id)
        validate_numerical_id(id)
        get_request("invoices/#{id}/download.pdf", headers: { content_type: 'application/pdf' })
      end

      def self.fire(id, event, params = {})
        request_params = permit_params(params, :paid_at, :paid_amount) || {}
        request_params[:event] = event

        validate_numerical_id(id)
        post_request("invoices/#{id}/fire.json", request_params: request_params)
      end

      def self.deliver_message(invoice_id, payload = {})
        validate_numerical_id(invoice_id)
        post_request("invoices/#{invoice_id}/message.json", payload: payload)
      end

      def self.create(payload = {})
        post_request('invoices.json', payload: payload)
      end

      def self.update(id, payload = {})
        validate_numerical_id(id)
        patch_request("invoices/#{id}.json", payload: payload)
      end

      def self.delete(id)
        validate_numerical_id(id)
        delete_request("invoices/#{id}.json")
      end
    end
  end
end
