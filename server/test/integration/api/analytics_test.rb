require "test_helper"

class Api::AnalyticsDataTest < ActionDispatch::IntegrationTest
  setup do
    @org = create_organization
    @role_member = create_role("content_team_member", [])
    @user = create_user
    assign_role(@user, @org, @role_member, ["analytics_data.index", "analytics_data.show"])

    @role_outsider = create_role("outsider", [])
    @outsider = create_user(email: "out@ex.com")
    assign_role(@outsider, @org, @role_outsider, [])
    
    @post = Post.create!(title: "Live", status: "published", category: "general", organization: @org, user: @user)
    AnalyticsData.create!(event_type: "view", event_data: { user_agent: "Chrome" }, recorded_at: Time.current, organization: @org, post: @post)
  end

  # AC-37: Only content_team_member can access /analytics. (Analytics index)
  test "content_team_member can view analytics" do
    get "/api/#{@org.slug}/analytics_data", headers: auth_headers(@user)
    assert_response :success
  end

  test "outsider cannot view analytics" do
    get "/api/#{@org.slug}/analytics_data", headers: auth_headers(@outsider)
    assert_response :forbidden
  end

  # AC-45: Data model stores event type
  test "analytics data stores event_type and event_data" do
    data = AnalyticsData.last
    assert_equal "view", data.event_type
    assert_equal "Chrome", data.event_data["user_agent"]
  end

  # AC-38, AC-39, AC-40, AC-41, AC-42, AC-43, AC-44, AC-60
  # Analytics Summary API
  test "returns analytics summary" do
    get "/api/analytics/summary", headers: auth_headers(@user)
    assert_response :success
    res = JSON.parse(response.body)
    assert res.key?("totalReach")
  end
end