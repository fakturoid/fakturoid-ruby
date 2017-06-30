module Fakturoid
  class Api
    module HttpMethods
      def get_request(path, params = {})
        Request.new(:get, path, self).call(params)
      end

      def post_request(path, params = {})
        Request.new(:post, path, self).call(params)
      end

      def patch_request(path, params = {})
        Request.new(:patch, path, self).call(params)
      end

      def delete_request(path, params = {})
        Request.new(:delete, path, self).call(params)
      end
    end
  end
end
