# frozen_string_literal: true

module Fakturoid
  module Api
    class Event
      include Base

      INDEX_PARAMS = [:page, :since, :subject_id].freeze

      def all(params = {})
        request_params = Utils.permit_params(params, *INDEX_PARAMS) || {}

        perform_request(HTTP_GET, "events.json", request_params: request_params)
      end

      def paid(params = {})
        request_params = Utils.permit_params(params, *INDEX_PARAMS) || {}

        perform_request(HTTP_GET, "events/paid.json", request_params: request_params)
      end
    end
  end
end
