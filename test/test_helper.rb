require 'minitest/autorun'
require 'mocha/setup'
require 'shoulda-context'
require 'pathname'
require 'fakturoid'

module Fakturoid
  class TestCase < Minitest::Test
    def test_path
      Pathname.new(File.dirname(__FILE__))
    end
    
    def load_fixture(file_name)
      File.read(test_path.join('fixtures', file_name))
    end
  end
end