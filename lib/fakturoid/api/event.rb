# frozen_string_literal: true

module Fakturoid
  module Api
    class Event
      include Common::Base

      def all(params = {})
        request_params = Utils.permit_params(params, :page, :since, :subject_id) || {}

        perform_request(HTTP_GET, "events.json", request_params: request_params)
      end

      def paid(params = {})
        request_params = Utils.permit_params(params, :page, :since, :subject_id) || {}

        perform_request(HTTP_GET, "events/paid.json", request_params: request_params)
      end
    end
  end
end
