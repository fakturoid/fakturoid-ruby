module Fakturoid
  class Api
    module Arguments
      def permit_params(params_hash, *permitted_params)
        params_hash.keep_if { |param, value| permitted_params.include?(param.to_sym) }
      end
      
      def validate_id(id)
        raise ArgumentError, "Wrong ID given: #{id}" unless id.is_a?(Integer)
      end
    end
  end
end