# frozen_string_literal: true

require "test_helper"

class Fakturoid::UtilsTest < Fakturoid::TestCase
  should "permit only required arguments" do
    hash = { page: 4, number: "2015-0015", account: 15 }
    permitted_params = Fakturoid::Utils.permit_params(hash, :page, :number, :status)
    assert_equal({ page: 4, number: "2015-0015" }, permitted_params)
  end

  should "raise argument error if id is in wrong format" do
    assert_raises(ArgumentError) { Fakturoid::Utils.validate_numerical_id(nil) }
    assert_raises(ArgumentError) { Fakturoid::Utils.validate_numerical_id("nil") }
    assert Fakturoid::Utils.validate_numerical_id(15)
    assert Fakturoid::Utils.validate_numerical_id("15")
  end

  should "raise argument error if search query is not given" do
    assert_raises(ArgumentError) { Fakturoid::Utils.validate_search_query(query: nil) }
    assert_raises(ArgumentError) { Fakturoid::Utils.validate_search_query(query: "") }
    assert Fakturoid::Utils.validate_search_query(query: "Company name")
  end
end
