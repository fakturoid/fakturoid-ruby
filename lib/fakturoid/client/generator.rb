module Fakturoid
  module Client
    class Generator < Fakturoid::Api
      def self.all(params = {})
        request_params = permit_params(params, :page, :since, :subject_id) || {}
        
        get_request('generators.json', request_params: request_params)
      end
      
      def self.recurring(params = {})
        request_params = permit_params(params, :page, :since, :subject_id) || {}
        
        get_request('generators/recurring.json', request_params: request_params)
      end
      
      def self.template(params = {})
        request_params = permit_params(params, :page, :since, :subject_id) || {}
        
        get_request('generators/template.json', request_params: request_params)
      end
      
      def self.find(id)
        validate_numerical_id(id)
        get_request("generators/#{id}.json")
      end
      
      def self.create(payload = {})
        post_request('generators.json', payload: payload)
      end
      
      def self.update(id, payload = {})
        validate_numerical_id(id)
        patch_request("generators/#{id}.json", payload: payload)
      end
      
      def self.delete(id)
        validate_numerical_id(id)
        delete_request("generators/#{id}.json")
      end
    end
  end
end
