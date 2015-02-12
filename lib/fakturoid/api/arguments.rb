module Fakturoid
  class Api
    module Arguments
      def permit_params(params_hash, *permitted_params)
        params_hash.select { |param, value| permitted_params.include?(param.to_sym) }
      end
      
      def validate_numerical_id(id)
        raise ArgumentError, "Wrong ID given: #{id}" if !id.is_a?(Integer) && !(id.is_a?(String) && id =~ /\A\d+\z/)
        true
      end
      
      def validate_search_query(query)
        raise ArgumentError, "Query parameter is required" if query.nil? || query.empty?
        true
      end
    end
  end
end