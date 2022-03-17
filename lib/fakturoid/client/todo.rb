# frozen_string_literal: true

module Fakturoid
  module Client
    class Todo < Fakturoid::Api
      def self.all(params = {})
        request_params = permit_params(params, :page, :since) || {}

        get_request("todos.json", request_params: request_params)
      end

      def self.toggle_completion(id)
        validate_numerical_id(id)
        post_request("todos/#{id}/toggle_completion.json")
      end
    end
  end
end
