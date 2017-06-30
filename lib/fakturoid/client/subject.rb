module Fakturoid
  module Client
    class Subject < Fakturoid::Api
      def self.all(params = {})
        request_params = permit_params(params, :page, :since, :updated_since, :custom_id) || {}

        get_request('subjects.json', request_params: request_params)
      end

      def self.find(id)
        validate_numerical_id(id)
        get_request("subjects/#{id}.json")
      end

      def self.search(query)
        validate_search_query(query)
        get_request('subjects/search.json', request_params: { query: query })
      end

      def self.create(payload = {})
        post_request('subjects.json', payload: payload)
      end

      def self.update(id, payload = {})
        validate_numerical_id(id)
        patch_request("subjects/#{id}.json", payload: payload)
      end

      def self.delete(id)
        validate_numerical_id(id)
        delete_request("subjects/#{id}.json")
      end
    end
  end
end
