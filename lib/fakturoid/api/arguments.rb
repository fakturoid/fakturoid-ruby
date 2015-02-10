module Fakturoid
  class Api
    module Arguments
      def permit_params(params_hash, *permitted_params)
        params_hash.keep_if { |param, value| permitted_params.include?(param.to_sym) }
      end
    end
  end
end