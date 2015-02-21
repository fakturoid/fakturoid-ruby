module Fakturoid
  module Client
    class Expense < Fakturoid::Api
      def self.all(params = {})
        request_params = permit_params(params, :page, :since, :number, :variable_symbol, :status, :subject_id) || {}
        
        get_request('expenses.json', request_params: request_params)
      end
      
      def self.find(id)
        validate_numerical_id(id)
        get_request("expenses/#{id}.json")
      end
      
      def self.search(query)
        validate_search_query(query)
        get_request("expenses/search.json", request_params: { query: query })
      end
      
      def self.fire(id, event)
        validate_numerical_id(id)
        post_request("expenses/#{id}/fire.json", request_params: { event: event })
      end
      
      def self.create(payload = {})
        post_request("expenses.json", payload: payload)
      end
      
      def self.update(id, payload = {})
        validate_numerical_id(id)
        patch_request("expenses/#{id}.json", payload: payload)
      end
      
      def self.delete(id)
        validate_numerical_id(id)
        delete_request("expenses/#{id}.json")
      end
    end
  end
end