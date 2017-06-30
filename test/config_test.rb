require 'test_helper'

class Fakturoid::ConfigTest < Fakturoid::TestCase
  should 'configure with block param' do
    config = Fakturoid::Config.new do |c|
      c.email   = 'test@email.cz'
      c.api_key = 'XXXXXXXXXXX'
      c.account = 'testaccount'
      c.user_agent = 'My test app (test@email.cz)'
    end

    assert_equal 'test@email.cz', config.email
    assert_equal 'XXXXXXXXXXX',   config.api_key
    assert_equal 'testaccount',   config.account
    assert_equal 'My test app (test@email.cz)', config.user_agent
  end

  should 'use default user agent' do
    config = Fakturoid::Config.new do |c|
      c.email   = 'test@email.cz'
      c.api_key = 'XXXXXXXXXXX'
      c.account = 'testaccount'
    end

    assert_equal 'Fakturoid ruby gem (test@email.cz)', config.user_agent
  end

  should 'return correct endpoints' do
    config = Fakturoid::Config.new do |c|
      c.email   = 'test@email.cz'
      c.api_key = 'XXXXXXXXXXX'
      c.account = 'testaccount'
    end

    assert_equal 'https://app.fakturoid.cz/api/v2/accounts/testaccount', config.endpoint
    assert_equal 'https://app.fakturoid.cz/api/v2', config.endpoint_without_account
  end
end
