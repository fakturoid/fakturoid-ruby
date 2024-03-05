# frozen_string_literal: true

module Fakturoid
  module Api
    class Todo
      include Base

      def all(params = {})
        request_params = Utils.permit_params(params, :page, :since) || {}

        perform_request(HTTP_GET, "todos.json", request_params: request_params)
      end

      def toggle_completion(id)
        Utils.validate_numerical_id(id)
        perform_request(HTTP_POST, "todos/#{id}/toggle_completion.json")
      end
    end
  end
end
