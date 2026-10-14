require "test_helper"

class Api::PostsTest < ActionDispatch::IntegrationTest
  setup do
    @org = create_organization
    @role_member = create_role("content_team_member", [])
    @user = create_user
    assign_role(@user, @org, @role_member, ["posts.index", "posts.show", "posts.store", "posts.update"])

    @role_outsider = create_role("outsider", [])
    @outsider = create_user(email: "out@ex.com")
    assign_role(@outsider, @org, @role_outsider, [])
  end

  # AC-1: Only content_team_member can access /create-post. (Backend enforcement: store)
  test "content_team_member can create a post" do
    assert_difference -> { Post.count }, 1 do
      post "/api/#{@org.slug}/posts", 
           params: { user_id: @user.id, title: "New Post", content: "Body", status: "published", category: "general" },
           headers: auth_headers(@user), as: :json
    end
    assert_response :created
  end

  test "outsider cannot create a post" do
    post "/api/#{@org.slug}/posts", 
         params: { user_id: @user.id, title: "New", content: "Body", status: "published", category: "general" },
         headers: auth_headers(@outsider), as: :json
    assert_response :forbidden
  end

  # AC-2: User can enter and format text content using a rich text editor.
  test "creates a post with formatted text" do
    post "/api/#{@org.slug}/posts", 
         params: { user_id: @user.id, title: "Fmt", content: "<b>Bold</b>", status: "published", category: "general" },
         headers: auth_headers(@user), as: :json
    assert_response :created
    assert_equal "<b>Bold</b>", Post.last.content
  end

  # AC-3: User can save a post as a draft.
  test "creates a post as a draft" do
    post "/api/#{@org.slug}/posts", 
         params: { user_id: @user.id, title: "Draft", content: "Pending", status: "draft", category: "general" },
         headers: auth_headers(@user), as: :json
    assert_response :created
    assert_equal "draft", Post.last.status
  end

  # AC-4: User can preview the post before publishing.
  # Backend aspect: user can fetch the post they just drafted
  test "user can view their draft post" do
    draft = Post.create!(title: "Draft", status: "draft", category: "general", organization: @org, user: @user)
    get "/api/#{@org.slug}/posts/#{draft.id}", headers: auth_headers(@user)
    assert_response :success
  end

  # AC-5: User can publish the post, making it live.
  test "user can update post status to published" do
    draft = Post.create!(title: "Draft", status: "draft", category: "general", organization: @org, user: @user)
    put "/api/#{@org.slug}/posts/#{draft.id}", 
        params: { user_id: @user.id, status: "published" },
        headers: auth_headers(@user), as: :json
    assert_response :success
    assert_equal "published", draft.reload.status
  end

  # AC-6: Published posts are visible on the blog.
  test "published posts are in the index" do
    Post.create!(title: "Live", status: "published", category: "general", organization: @org, user: @user)
    get "/api/#{@org.slug}/posts", headers: auth_headers(@user)
    assert_response :success
    data = JSON.parse(response.body)
    puts response.body
    assert_equal 1, data["data"].length
    assert_equal "Live", data["data"][0]["title"]
  end

  # AC-9: Only content_team_member can edit published posts.
  test "content_team_member can edit published posts" do
    live = Post.create!(title: "Live", status: "published", category: "general", organization: @org, user: @user)
    put "/api/#{@org.slug}/posts/#{live.id}", params: { user_id: @user.id, title: "Updated" }, headers: auth_headers(@user), as: :json
    assert_response :success
  end

  test "outsider cannot edit published posts" do
    live = Post.create!(title: "Live", status: "published", category: "general", organization: @org, user: @user)
    put "/api/#{@org.slug}/posts/#{live.id}", params: { user_id: @user.id, title: "Updated" }, headers: auth_headers(@outsider), as: :json
    assert_response :forbidden
  end

  # AC-11: User can modify text and media within the post.
  test "user can modify text" do
    live = Post.create!(title: "Live", status: "published", category: "general", organization: @org, user: @user)
    put "/api/#{@org.slug}/posts/#{live.id}", params: { user_id: @user.id, content: "New text" }, headers: auth_headers(@user), as: :json
    assert_response :success
    assert_equal "New text", live.reload.content
  end

  # AC-12: User can save changes, which are immediately reflected on the live blog.
  test "changes are saved and reflected" do
    live = Post.create!(title: "Live", status: "published", category: "general", organization: @org, user: @user)
    put "/api/#{@org.slug}/posts/#{live.id}", params: { user_id: @user.id, title: "Reflected" }, headers: auth_headers(@user), as: :json
    get "/api/#{@org.slug}/posts/#{live.id}", headers: auth_headers(@user)
    assert_equal "Reflected", JSON.parse(response.body)["title"]
  end

  # AC-59: Needs virtual attributes views, hasVideo, videoDuration, and date on Post.
  test "returns virtual attributes for post" do
    live = Post.create!(title: "Live", status: "published", category: "general", organization: @org, user: @user, published_at: Time.zone.parse('2023-10-20'))
    get "/api/#{@org.slug}/posts/#{live.id}?fields=views,hasVideo,videoDuration,date", headers: auth_headers(@user)
    assert_response :success
    res = JSON.parse(response.body)
    puts res
    assert res.key?("views")
    assert res.key?("hasVideo")
    assert res.key?("videoDuration")
    assert_equal "2023-10-20", res["date"]
  end
end