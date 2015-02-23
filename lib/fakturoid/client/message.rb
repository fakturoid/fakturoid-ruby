module Fakturoid
  module Client
    class Message < Fakturoid::Api
      def self.create(invoice_id, payload = {})
        validate_numerical_id(invoice_id)
        post_request("invoices/#{invoice_id}/message.json", payload: payload)
      end
    end
  end
end