module Fakturoid
  module Client
    class Event < Fakturoid::Api
      def self.all(params = {})
        request_params = permit_params(params, :page, :since, :subject_id) || {}

        get_request('events.json', request_params: request_params)
      end

      def self.paid(params = {})
        request_params = permit_params(params, :page, :since, :subject_id) || {}

        get_request('events/paid.json', request_params: request_params)
      end
    end
  end
end
