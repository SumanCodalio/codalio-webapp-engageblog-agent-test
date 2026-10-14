require "test_helper"

class Api::AnalyticsControllerTest < ActionDispatch::IntegrationTest
  # AC-15: Analytics Summary API
  test "should get summary" do
    get "/api/analytics/summary"
    assert_response :success
  end
end
