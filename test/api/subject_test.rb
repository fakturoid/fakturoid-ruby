# frozen_string_literal: true

require "test_helper"

class Fakturoid::Api::SubjectTest < Fakturoid::TestCase
  should "get all" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, name: "Apple Czech s.r.o." }]
      stub.get("subjects.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert 1, test_client.subject.all.body.size
  end

  should "search" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, name: "Apple Czech s.r.o." }]
      stub.get("subjects/search.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert 1, test_client.subject.search("Apple").body.size
  end

  should "get detail" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, name: "Apple Czech s.r.o." }
      stub.get("subjects/1.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert 1, test_client.subject.find(1).body.size
  end

  should "create new record" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, name: "Apple Czech s.r.o." }
      stub.post("subjects.json") { |_env| [201, { content_type: "application/json" }, response_data.to_json] }
    end

    assert 1, test_client.subject.create(name: "Apple Czech s.r.o.").id
  end

  should "update record" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, name: "Google Czech Republic s.r.o." }
      stub.patch("subjects/1.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert 1, test_client.subject.update(1, name: "Google Czech Republic s.r.o.").id
  end

  should "delete record" do
    mock_faraday_connection do |stub|
      stub.delete("subjects/1.json") { |_env| [204, {}, ""] }
    end

    test_client.subject.delete(1)
  end
end
