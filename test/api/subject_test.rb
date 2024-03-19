# frozen_string_literal: true

require "test_helper"

class Fakturoid::Api::SubjectTest < Fakturoid::TestCase
  should "get all" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, name: "Apple Czech s.r.o." }]
      stub.get("subjects.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.subjects.all.body.size
  end

  should "search" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, name: "Apple Czech s.r.o." }]
      stub.strict_mode = true
      stub.get("subjects/search.json?query=Apple", content_type: "application/json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.subjects.search(query: "Apple").body.size
  end

  should "get detail" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, name: "Apple Czech s.r.o." }
      stub.get("subjects/1.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.subjects.find(1).id
  end

  should "create new record" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, name: "Apple Czech s.r.o." }
      stub.post("subjects.json") { |_env| [201, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.subjects.create(name: "Apple Czech s.r.o.").id
  end

  should "update record" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, name: "Google Czech Republic s.r.o." }
      stub.patch("subjects/1.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.subjects.update(1, name: "Google Czech Republic s.r.o.").id
  end

  should "delete record" do
    mock_faraday_connection do |stub|
      stub.delete("subjects/1.json") { |_env| [204, {}, ""] }
    end

    assert_equal 204, test_client.subjects.delete(1).status_code
  end
end
