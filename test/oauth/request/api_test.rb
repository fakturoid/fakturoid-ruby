# frozen_string_literal: true

require "test_helper"

class Fakturoid::Oauth::Request::ApiTest < Fakturoid::TestCase
  should "should return pdf" do
    skip "This test was not working and will be redone in invoice test"

    pdf = load_fixture("invoice.pdf")
    test_connection = Faraday.new do |builder|
      builder.adapter :test do |stub|
        stub.get("invoices/5/download.pdf") { |_env| [200, { content_type: "application/pdf" }, pdf] }
      end
      builder.headers = { content_type: "application/pdf" }
    end
    Fakturoid::Oauth::Request::Api.any_instance.stubs(:connection).returns(test_connection)

    response = Fakturoid::Oauth::Request::Api.new(:get, "invoices/5/download.pdf", Fakturoid::Client::Invoice).call
    assert !response.json?
    assert_raises(NoMethodError) { response.name }
  end
end
