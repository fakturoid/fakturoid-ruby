require 'fakturoid/api/http_methods'


module Fakturoid
  class Api
    extend HttpMethods
    
    def self.configure(&block)
      @config ||= Fakturoid::Config.new(&block)
    end
    
    def self.config
      @config
    end
  end
end