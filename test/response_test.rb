# frozen_string_literal: true

require "test_helper"

class Fakturoid::ResponseTest < Fakturoid::TestCase
  def mock_faraday_connection(params = {}, &block)
    Faraday.new do |builder|
      builder.adapter(:test, &block)
      builder.headers = params[:headers] || { content_type: "application/json", user_agent: "Fakturoid gem (email@testmail.cz)" }
    end
  end

  should "return json invoice" do
    test_connection = mock_faraday_connection do |stub|
      stub.get("invoices/5.json") { |_env| [200, { content_type: "application/json" }, load_fixture("invoice.json")] }
    end

    response = Fakturoid::Response.new(test_connection.get("invoices/5.json"), Fakturoid::Api::Invoice, Fakturoid::HTTP_GET)
    assert response.json?
    assert_equal 200, response.status_code
    assert_equal 5,   response.id
    assert_equal 5,   response.body["id"]
    assert response.respond_to?(:body)
    assert response.respond_to?(:id)
    assert_raises(NoMethodError) { response.name }
  end

  context "Exceptions" do
    should "raise pagination error" do
      test_connection = mock_faraday_connection do |stub|
        stub.get("invoices.json?page=4") { |_env| [400, { content_type: "application/json" }, " "] }
      end

      assert_raises(Fakturoid::ClientError) { Fakturoid::Response.new(test_connection.get("invoices.json?page=4"), Fakturoid::Api::Invoice, Fakturoid::HTTP_GET) }
    end

    should "raise authentication error" do
      test_connection = mock_faraday_connection do |stub|
        stub.get("invoices.json?page=4") { |_env| [401, { content_type: "application/json" }, " "] }
      end

      assert_raises(Fakturoid::AuthenticationError) { Fakturoid::Response.new(test_connection.get("invoices.json?page=4"), Fakturoid::Api::Invoice, Fakturoid::HTTP_GET) }
    end

    should "raise blocked account error" do
      test_connection = mock_faraday_connection do |stub|
        stub.get("account.json") { |_env| [402, { content_type: "application/json" }, load_fixture("blocked_account.json")] }
      end

      begin
        Fakturoid::Response.new(test_connection.get("account.json"), Fakturoid::Api::Account, Fakturoid::HTTP_GET)
      rescue Fakturoid::ClientError => e
        assert_equal 402, e.response_code
        assert e.response_body.key?("status")
      rescue => e
        assert false, "Raised exception was not expected: #{e.class}"
      else
        assert false, "Exception was expected"
      end
    end

    should "raise destroy subject error" do
      test_connection = mock_faraday_connection do |stub|
        stub.delete("subjects/5.json") { |_env| [403, { content_type: "application/json" }, " "] }
      end

      assert_raises(Fakturoid::ClientError) { Fakturoid::Response.new(test_connection.delete("subjects/5.json"), Fakturoid::Api::Subject, Fakturoid::HTTP_DELETE) }
    end

    should "raise subject limit error" do
      test_connection = mock_faraday_connection do |stub|
        stub.post("subjects.json") { |_env| [403, { content_type: "application/json" }, " "] }
      end

      assert_raises(Fakturoid::ClientError) { Fakturoid::Response.new(test_connection.post("subjects.json", name: "Customer s.r.o."), Fakturoid::Api::Subject, Fakturoid::HTTP_POST) }
    end

    should "raise generator limit error" do
      test_connection = mock_faraday_connection do |stub|
        stub.post("generators.json") { |_env| [403, { content_type: "application/json" }, " "] }
      end

      assert_raises(Fakturoid::ClientError) { Fakturoid::Response.new(test_connection.post("generators.json", name: "Customer s.r.o.", recurring: true), Fakturoid::Api::Generator, Fakturoid::HTTP_POST) }
    end

    should "raise unsupported feature error" do
      test_connection = mock_faraday_connection do |stub|
        stub.post("invoices/5/message.json") { |_env| [403, { content_type: "application/json" }, " "] }
      end

      assert_raises(Fakturoid::ClientError) { Fakturoid::Response.new(test_connection.post("invoices/5/message.json", email: "customer@email.cz"), Fakturoid::Api::Invoice, Fakturoid::HTTP_POST) }
    end

    should "raise record not found error" do
      test_connection = mock_faraday_connection do |stub|
        stub.get("invoices/10.json") { |_env| [404, { content_type: "application/json" }, " "] }
      end

      assert_raises(Fakturoid::ClientError) { Fakturoid::Response.new(test_connection.get("invoices/10.json"), Fakturoid::Api::Invoice, Fakturoid::HTTP_GET) }
    end

    should "raise content type error" do
      test_connection = mock_faraday_connection(headers: { content_type: "application/xml", user_agent: "Fakturoid gem (email@testmail.cz)" }) do |stub|
        stub.get("invoices/5.xml") { |_env| [415, { content_type: "application/xml" }, " "] }
      end

      assert_raises(Fakturoid::ClientError) { Fakturoid::Response.new(test_connection.get("invoices/5.xml"), Fakturoid::Api::Invoice, Fakturoid::HTTP_GET) }
    end

    should "raise invalid record error" do
      test_connection = mock_faraday_connection do |stub|
        stub.patch("invoice/5.json") { |_env| [422, { content_type: "application/json" }, load_fixture("invoice_error.json")] }
      end

      begin
        Fakturoid::Response.new(test_connection.patch("invoice/5.json"), Fakturoid::Api::Invoice, Fakturoid::HTTP_PATCH)
      rescue Fakturoid::ClientError => e
        assert_equal 422, e.response_code
        assert e.response_body.key?("errors")
      rescue => e
        assert false, "Raised exception was not expected: #{e.class}"
      else
        assert false, "Exception was expected"
      end
    end

    should "raise rate limit error" do
      test_connection = mock_faraday_connection do |stub|
        stub.get("invoices/5.json") { |_env| [429, { content_type: "application/json" }, " "] }
      end

      assert_raises(Fakturoid::ClientError) { Fakturoid::Response.new(test_connection.get("invoices/5.json"), Fakturoid::Api::Invoice, Fakturoid::HTTP_GET) }
    end

    should "raise read only site error" do
      test_connection = mock_faraday_connection do |stub|
        stub.delete("invoices/5.json") { |_env| [503, { content_type: "application/json" }, " "] }
      end

      assert_raises(Fakturoid::ServerError) { Fakturoid::Response.new(test_connection.delete("invoices/5.json"), Fakturoid::Api::Invoice, Fakturoid::HTTP_DELETE) }
    end
  end
end
