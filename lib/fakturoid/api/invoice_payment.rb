# frozen_string_literal: true

module Fakturoid
  module Api
    class InvoicePayment
      include Common::Base

      def create(invoice_id, payload = {})
        Utils.validate_numerical_id(invoice_id)
        perform_request(HTTP_POST, "invoices/#{invoice_id}/payments.json", payload: payload)
      end

      def create_tax_document(invoice_id, id)
        Utils.validate_numerical_id(invoice_id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_POST, "invoices/#{invoice_id}/payments/#{id}/create_tax_document.json")
      end

      def delete(invoice_id, id)
        Utils.validate_numerical_id(invoice_id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_DELETE, "invoices/#{invoice_id}/payments/#{id}.json")
      end
    end
  end
end
