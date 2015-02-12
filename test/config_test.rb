require 'test_helper'

class ConfigTest < Minitest::Test
  should "configure with block param" do
    config = Fakturoid::Config.new do |config|
      config.email   = 'test@email.cz'
      config.api_key = 'XXXXXXXXXXX'
      config.account = 'testaccount'
      config.user_agent = 'My test app (test@email.cz)'
    end
    
    assert_equal 'test@email.cz', config.email
    assert_equal 'XXXXXXXXXXX',   config.api_key
    assert_equal 'testaccount',   config.account
    assert_equal 'My test app (test@email.cz)', config.user_agent
  end
  
  should "use default user agent" do
    config = Fakturoid::Config.new do |config|
      config.email   = 'test@email.cz'
      config.api_key = 'XXXXXXXXXXX'
      config.account = 'testaccount'
    end

    assert_equal 'Fakturoid ruby gem (test@email.cz)', config.user_agent
  end
end