require "test_helper"

class Api::AuthTest < ActionDispatch::IntegrationTest
  setup do
    @org = create_organization
    @role_admin = create_role("admin", [])
    @admin = create_user(email: "admin@example.com", password: "password123")
    assign_role(@admin, @org, @role_admin, [])
  end

  # AC-23: Unauthenticated users are redirected (Backend: return 401)
  # AC-24: User can enter email and password on the login page.
  # AC-25: Successful login redirects admin to /admin/dashboard.
  test "successful login returns auth token" do
    post "/api/auth/login", params: { email: "admin@example.com", password: "password123" }, as: :json
    puts response.body
    assert_response :success
    assert JSON.parse(response.body)["token"].present?
  end

  # AC-26: Failed login attempts display an error message.
  test "failed login returns unauthorized" do
    post "/api/auth/login", params: { email: "admin@example.com", password: "wrong" }, as: :json
    assert_response :unauthorized
  end

  # AC-34: User can click a logout button.
  # AC-35: Successful logout redirects...
  # AC-36: After logout, the user cannot access protected routes
  test "logout invalidates the session" do
    post "/api/auth/login", params: { email: "admin@example.com", password: "password123" }, as: :json
    token = JSON.parse(response.body)["token"]

    post "/api/auth/logout", headers: { "Authorization" => "Bearer #{token}" }
    assert_response :success

    get "/api/#{@org.slug}/users", headers: { "Authorization" => "Bearer #{token}" }
    assert_response :unauthorized
  end
end