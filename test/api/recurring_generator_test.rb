# frozen_string_literal: true

require "test_helper"

class Fakturoid::Api::RecurringGeneratorTest < Fakturoid::TestCase
  should "get all" do
    mock_faraday_connection do |stub|
      response_data = [{ id: 1, name: "Workshop" }]
      stub.get("recurring_generators.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.recurring_generators.all.body.size
  end

  should "get detail" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, name: "Workshop" }
      stub.get("recurring_generators/1.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.recurring_generators.find(1).id
  end

  should "create new record" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, name: "Workshop" }
      stub.post("recurring_generators.json") { |_env| [201, { content_type: "application/json" }, response_data.to_json] }
    end

    data = {
      name: "Workshop",
      subject_id: 1,
      start_date: Date.today,
      months_period: 1,
      lines: [{ name: "Workshop", unit_price: 1000, vat_rate: 21 }]
    }
    assert_equal 1, test_client.recurring_generators.create(data).id
  end

  should "update record" do
    mock_faraday_connection do |stub|
      response_data = { id: 1, name: "Longer workshop" }
      stub.patch("recurring_generators/1.json") { |_env| [200, { content_type: "application/json" }, response_data.to_json] }
    end

    assert_equal 1, test_client.recurring_generators.update(1, name: "Longer workshop").id
  end

  should "delete record" do
    mock_faraday_connection do |stub|
      stub.delete("recurring_generators/1.json") { |_env| [204, {}, ""] }
    end

    assert_equal 204, test_client.recurring_generators.delete(1).status_code
  end
end
