# frozen_string_literal: true

require "test_helper"

class Fakturoid::Api::GeneratorTest < Fakturoid::TestCase
  should "get all" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, name: "Workshop" }]
      stub.get("generators.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.generator.all.body.size
  end

  should "get detail" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, name: "Workshop" }
      stub.get("generators/1.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.generator.find(1).id
  end

  should "create new record" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, name: "Workshop" }
      stub.post("generators.json") { |_env| [201, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.generator.create(name: "Workshop", subject_id: 1, lines: [{ name: "Workshop", unit_price: 1000, vat_rate: 21 }]).id
  end

  should "update record" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, name: "Longer workshop" }
      stub.patch("generators/1.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.generator.update(1, name: "Longer workshop").id
  end

  should "delete record" do
    mock_faraday_connection do |stub|
      stub.delete("generators/1.json") { |_env| [204, {}, ""] }
    end

    assert_equal 204, test_client.generator.delete(1).status_code
  end
end
