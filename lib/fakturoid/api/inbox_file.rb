# frozen_string_literal: true

module Fakturoid
  module Api
    class InboxFile
      include Common::Base

      def all(params = {})
        request_params = Utils.permit_params(params, :page)

        perform_request(HTTP_GET, "inbox_files.json", request_params: request_params)
      end

      def create(payload = {})
        perform_request(HTTP_POST, "inbox_files.json", payload: payload)
      end

      def send_to_ocr(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_POST, "inbox_files/#{id}/send_to_ocr.json")
      end

      def download(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_GET, "inbox_files/#{id}/download")
      end

      def delete(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_DELETE, "inbox_files/#{id}.json")
      end
    end
  end
end
