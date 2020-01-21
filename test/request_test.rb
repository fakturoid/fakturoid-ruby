# frozen_string_literal: true

require 'test_helper'

class Fakturoid::RequestTest < Fakturoid::TestCase
  should 'should return pdf' do
    pdf = load_fixture('invoice.pdf')
    test_connection = Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get('invoices/5/download.pdf') { |_env| [200, { content_type: 'application/pdf' }, pdf] }
      end
      builder.headers = { content_type: 'application/pdf' }
    end
    Fakturoid::Request.any_instance.stubs(:connection).returns(test_connection)

    response = Fakturoid::Request.new(:get, 'invoices/5/download.pdf', Fakturoid::Client::Invoice).call
    assert !response.json?
    assert_raises(NoMethodError) { response.name }
  end
end
