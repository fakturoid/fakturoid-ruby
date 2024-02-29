# frozen_string_literal: true

module Fakturoid
  module Api
    class InvoiceMessage
      include Common::Base

      def create(invoice_id, payload = {})
        Utils.validate_numerical_id(invoice_id)
        perform_request(HTTP_POST, "invoices/#{invoice_id}/message.json", payload: payload)
      end
    end
  end
end
