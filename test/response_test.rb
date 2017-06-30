require 'test_helper'

class Fakturoid::ResponseTest < Fakturoid::TestCase
  should 'should return json invoice' do
    json = load_fixture('invoice.json')
    test_connection = Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get('invoices/5.json') { |_env| [200, { content_type: 'application/json' }, json] }
      end
      builder.headers = { content_type: 'application/json', user_agent: 'Fakturoid gem (email@testmail.cz)' }
    end

    response = Fakturoid::Response.new(test_connection.get('invoices/5.json'), Fakturoid::Client::Invoice, :get)
    assert response.json?
    assert_equal 200, response.status_code
    assert_equal 5,   response.id
    assert_equal 5,   response.body['id']
    assert response.respond_to?(:body)
    assert response.respond_to?(:id)
    assert_raises(NoMethodError) { response.name }
  end

  context 'Exceptions' do
    should 'raise user agent error' do
      test_connection = Faraday.new do |builder|
        builder.adapter :test do |stub|
          stub.get('invoices/5.json') { |_env| [400, { content_type: 'application/json' }, ' '] }
        end
        builder.headers = { content_type: 'application/json', user_agent: '' }
      end

      assert_raises(Fakturoid::UserAgentError) { Fakturoid::Response.new(test_connection.get('invoices/5.json'), Fakturoid::Client::Invoice, :get) }
    end

    should 'raise pagination error' do
      test_connection = Faraday.new do |builder|
        builder.adapter :test do |stub|
          stub.get('invoices.json?page=4') { |_env| [400, { content_type: 'application/json' }, ' '] }
        end
        builder.headers = { content_type: 'application/json', user_agent: 'Fakturoid gem (email@testmail.cz)' }
      end

      assert_raises(Fakturoid::PaginationError) { Fakturoid::Response.new(test_connection.get('invoices.json?page=4'), Fakturoid::Client::Invoice, :get) }
    end

    should 'raise authentication error' do
      test_connection = Faraday.new do |builder|
        builder.adapter :test do |stub|
          stub.get('invoices.json?page=4') { |_env| [401, { content_type: 'application/json' }, ' '] }
        end
        builder.headers = { content_type: 'application/json', user_agent: 'Fakturoid gem (email@testmail.cz)' }
      end

      assert_raises(Fakturoid::AuthenticationError) { Fakturoid::Response.new(test_connection.get('invoices.json?page=4'), Fakturoid::Client::Invoice, :get) }
    end

    should 'raise blocked account error' do
      json = load_fixture('blocked_account.json')
      test_connection = Faraday.new do |builder|
        builder.adapter :test do |stub|
          stub.get('account.json') { |_env| [402, { content_type: 'application/json' }, json] }
        end
        builder.headers = { content_type: 'application/json', user_agent: 'Fakturoid gem (email@testmail.cz)' }
      end

      begin
        Fakturoid::Response.new(test_connection.get('account.json'), Fakturoid::Client::Account, :get)
      rescue Fakturoid::BlockedAccountError => e
        assert_equal 402, e.response_code
        assert e.response_body.key?('status')
      rescue => e
        assert false, "Raised exception was not expected: #{e.class}"
      else
        assert false, 'Exception was expected'
      end
    end

    should 'raise destroy subject error' do
      test_connection = Faraday.new do |builder|
        builder.adapter :test do |stub|
          stub.delete('subjects/5.json') { |_env| [403, { content_type: 'application/json' }, ' '] }
        end
        builder.headers = { content_type: 'application/json', user_agent: 'Fakturoid gem (email@testmail.cz)' }
      end

      assert_raises(Fakturoid::DestroySubjectError) { Fakturoid::Response.new(test_connection.delete('subjects/5.json'), Fakturoid::Client::Subject, :delete) }
    end

    should 'raise subject limit error' do
      test_connection = Faraday.new do |builder|
        builder.adapter :test do |stub|
          stub.post('subjects.json') { |_env| [403, { content_type: 'application/json' }, ' '] }
        end
        builder.headers = { content_type: 'application/json', user_agent: 'Fakturoid gem (email@testmail.cz)' }
      end

      assert_raises(Fakturoid::SubjectLimitError) { Fakturoid::Response.new(test_connection.post('subjects.json', name: 'Customer s.r.o.'), Fakturoid::Client::Subject, :post) }
    end

    should 'raise generator limit error' do
      test_connection = Faraday.new do |builder|
        builder.adapter :test do |stub|
          stub.post('generators.json') { |_env| [403, { content_type: 'application/json' }, ' '] }
        end
        builder.headers = { content_type: 'application/json', user_agent: 'Fakturoid gem (email@testmail.cz)' }
      end

      assert_raises(Fakturoid::GeneratorLimitError) { Fakturoid::Response.new(test_connection.post('generators.json', name: 'Customer s.r.o.', recurring: true), Fakturoid::Client::Generator, :post) }
    end

    should 'raise unsupported feature error' do
      test_connection = Faraday.new do |builder|
        builder.adapter :test do |stub|
          stub.post('invoices/5/message.json') { |_env| [403, { content_type: 'application/json' }, ' '] }
        end
        builder.headers = { content_type: 'application/json', user_agent: 'Fakturoid gem (email@testmail.cz)' }
      end

      assert_raises(Fakturoid::UnsupportedFeatureError) { Fakturoid::Response.new(test_connection.post('invoices/5/message.json', email: 'customer@email.cz'), Fakturoid::Client::Invoice, :post) }
    end

    should 'raise record not found error' do
      test_connection = Faraday.new do |builder|
        builder.adapter :test do |stub|
          stub.get('invoices/10.json') { |_env| [404, { content_type: 'application/json' }, ' '] }
        end
        builder.headers = { content_type: 'application/json', user_agent: 'Fakturoid gem (email@testmail.cz)' }
      end

      assert_raises(Fakturoid::RecordNotFoundError) { Fakturoid::Response.new(test_connection.get('invoices/10.json'), Fakturoid::Client::Invoice, :get) }
    end

    should 'raise content type error' do
      test_connection = Faraday.new do |builder|
        builder.adapter :test do |stub|
          stub.get('invoices/5.xml') { |_env| [415, { content_type: 'application/xml' }, ' '] }
        end
        builder.headers = { content_type: 'application/xml', user_agent: 'Fakturoid gem (email@testmail.cz)' }
      end

      assert_raises(Fakturoid::ContentTypeError) { Fakturoid::Response.new(test_connection.get('invoices/5.xml'), Fakturoid::Client::Invoice, :get) }
    end

    should 'raise invalid record error' do
      json = load_fixture('invoice_error.json')
      test_connection = Faraday.new do |builder|
        builder.adapter :test do |stub|
          stub.patch('invoice/5.json') { |_env| [422, { content_type: 'application/json' }, json] }
        end
        builder.headers = { content_type: 'application/json', user_agent: 'Fakturoid gem (email@testmail.cz)' }
      end

      begin
        Fakturoid::Response.new(test_connection.patch('invoice/5.json'), Fakturoid::Client::Invoice, :patch)
      rescue Fakturoid::InvalidRecordError => e
        assert_equal 422, e.response_code
        assert e.response_body.key?('errors')
      rescue => e
        assert false, "Raised exception was not expected: #{e.class}"
      else
        assert false, 'Exception was expected'
      end
    end

    should 'raise rate limit error' do
      test_connection = Faraday.new do |builder|
        builder.adapter :test do |stub|
          stub.get('invoices/5.json') { |_env| [429, { content_type: 'application/json' }, ' '] }
        end
        builder.headers = { content_type: 'application/json', user_agent: 'Fakturoid gem (email@testmail.cz)' }
      end

      assert_raises(Fakturoid::RateLimitError) { Fakturoid::Response.new(test_connection.get('invoices/5.json'), Fakturoid::Client::Invoice, :get) }
    end

    should 'raise read only site error' do
      test_connection = Faraday.new do |builder|
        builder.adapter :test do |stub|
          stub.delete('invoices/5.json') { |_env| [503, { content_type: 'application/json' }, ' '] }
        end
        builder.headers = { content_type: 'application/json', user_agent: 'Fakturoid gem (email@testmail.cz)' }
      end

      assert_raises(Fakturoid::ReadOnlySiteError) { Fakturoid::Response.new(test_connection.delete('invoices/5.json'), Fakturoid::Client::Invoice, :delete) }
    end
  end
end
