require "test_helper"

class Api::UsersTest < ActionDispatch::IntegrationTest
  setup do
    @org = create_organization
    @role_admin = create_role("admin", [])
    @admin = create_user(email: "admin@example.com")
    assign_role(@admin, @org, @role_admin, ["users.index", "users.show", "users.store", "users.update", "users.destroy"])

    @role_member = create_role("content_team_member", [])
    @member = create_user(email: "member@example.com")
    assign_role(@member, @org, @role_member, [])
  end

  # AC-27: Only admin can access /admin/users (Backend: users index endpoint)
  test "admin can list users" do
    get "/api/#{@org.slug}/users", headers: auth_headers(@admin)
    assert_response :success
  end

  # AC-56: content_team_member cannot access /admin routes (Users endpoint)
  test "content_team_member cannot list users" do
    get "/api/#{@org.slug}/users", headers: auth_headers(@member)
    assert_response :forbidden
  end

  # AC-28: Admin can view a list of existing content_team_member accounts.
  test "users index returns existing users" do
    get "/api/#{@org.slug}/users", headers: auth_headers(@admin)
    assert_response :success
    data = JSON.parse(response.body)["data"]
    assert data.length >= 2
  end

  # AC-29: Admin can create a new content_team_member account with a name, email, and password.
  test "admin can create a user" do
    assert_difference -> { User.count }, 1 do
      post "/api/#{@org.slug}/users", 
           params: { name: "New", email: "new#{rand(100)}@ex.com", password: "pwd", password_confirmation: "pwd" },
           headers: auth_headers(@admin), as: :json
    end
    assert_response :created
  end

  # AC-30: Admin can edit an existing content_team_member's details.
  test "admin can update user" do
    put "/api/#{@org.slug}/users/#{@member.id}", 
        params: { name: "Updated Name" },
        headers: auth_headers(@admin), as: :json
    assert_response :success
    assert_equal "Updated Name", @member.reload.name
  end

  # AC-31: Admin can deactivate or delete a content_team_member account.
  test "admin can delete user" do
    assert_difference -> { User.count }, -1 do
      delete "/api/#{@org.slug}/users/#{@member.id}", headers: auth_headers(@admin)
    end
    assert_response :success
  end

  # AC-32: Data model stores first name
  # AC-33: Data model stores last name
  # AC-7: Data model stores approved
  # AC-8: Data model stores profile completed
  test "user model stores first_name, last_name, approved, profile_completed" do
    post "/api/#{@org.slug}/users", 
         params: { 
           name: "John Doe",
           email: "test2#{rand(100)}@ex.com", 
           password: "pwd", 
           first_name: "John", 
           last_name: "Doe", 
           approved: true, 
           profile_completed: true 
         },
         headers: auth_headers(@admin), as: :json
    assert_response :created
    u = User.last
    assert_equal "John", u.first_name
    assert_equal "Doe", u.last_name
    assert_equal true, u.approved
    assert_equal true, u.profile_completed
  end

  # AC-57: admin has full access to all application features and data
  # Already tested via posts, videos, users access.
  # AC-58: Unauthorized access attempts are logged and blocked
  test "unauthorized requests are blocked with 401 or 403" do
    get "/api/#{@org.slug}/users"
    assert_response :unauthorized
  end
end