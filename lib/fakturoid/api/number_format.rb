# frozen_string_literal: true

module Fakturoid
  module Api
    class NumberFormat
      include Common::Base

      def invoices
        perform_request(HTTP_GET, "number_formats/invoices.json")
      end
    end
  end
end
