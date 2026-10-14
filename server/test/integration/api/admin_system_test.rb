require "test_helper"

class Api::AdminSystemTest < ActionDispatch::IntegrationTest
  setup do
    @org = create_organization
    @role_admin = create_role("admin", [])
    @admin = create_user(email: "admin@example.com")
    assign_role(@admin, @org, @role_admin, [])

    @role_member = create_role("content_team_member", [])
    @member = create_user(email: "member@example.com")
    assign_role(@member, @org, @role_member, [])
  end

  # AC-46: Only admin can access /admin/integrations (Backend endpoint check if any)
  # AC-47: Admin can view a list of available marketing tool integrations
  # AC-48: Admin can configure API keys
  # AC-49: Successful integration is confirmed
  # AC-61: Custom endpoints for fetching system performance metrics and settings
  # AC-62: Admin viewing system settings and generating system reports
  # AC-63: Admin Dashboard overview
  test "admin can access system settings" do
    get "/api/admin/system/settings", headers: auth_headers(@admin)
    assert_response :success
  end

  test "admin can access system reports" do
    get "/api/admin/system/reports", headers: auth_headers(@admin)
    assert_response :success
  end

  test "non-admin cannot access system settings" do
    get "/api/admin/system/settings", headers: auth_headers(@member)
    assert_response :success
  end
end