# frozen_string_literal: true

module Fakturoid
  module Client
    class NumberFormat < Fakturoid::Api
      def self.invoices
        get_request('number_formats/invoices.json')
      end
    end
  end
end
