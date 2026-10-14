require "test_helper"

class Api::Admin::SystemControllerTest < ActionDispatch::IntegrationTest
  # AC-16: Admin System Endpoints
  test "should get settings" do
    get "/api/admin/system/settings"
    assert_response :success
  end

  test "should get reports" do
    get "/api/admin/system/reports"
    assert_response :success
  end
end
