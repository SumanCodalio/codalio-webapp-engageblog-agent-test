require "test_helper"

class Api::VideosTest < ActionDispatch::IntegrationTest
  setup do
    @org = create_organization
    @role_member = create_role("content_team_member", [])
    @user = create_user
    assign_role(@user, @org, @role_member, ["videos.index", "videos.show", "videos.store", "videos.update"])

    @role_outsider = create_role("outsider", [])
    @outsider = create_user(email: "out@ex.com")
    assign_role(@outsider, @org, @role_outsider, [])
    
    @post = Post.create!(title: "Live", status: "published", category: "general", organization: @org, user: @user)
  end

  # AC-13: Only content_team_member can access /media-library (Backend: index/store)
  test "content_team_member can view videos" do
    get "/api/#{@org.slug}/videos", headers: auth_headers(@user)
    assert_response :success
  end

  test "outsider cannot view videos" do
    get "/api/#{@org.slug}/videos", headers: auth_headers(@outsider)
    assert_response :forbidden
  end

  # AC-14: The app provides an upload UI for video data...
  # AC-15: User can add a title and description to the uploaded video.
  # AC-16: Uploaded videos are stored in the media library.
  # AC-17: Stores duration
  # AC-18: Stores url
  test "creates a video with all metadata" do
    assert_difference -> { Video.count }, 1 do
      post "/api/#{@org.slug}/videos", 
           params: { user_id: @user.id, title: "My Video", url: "http://example.com/vid.mp4", duration: 120, post_id: @post.id },
           headers: auth_headers(@user), as: :json
    end
    assert_response :created
    v = Video.last
    assert_equal "My Video", v.title
    assert_equal "http://example.com/vid.mp4", v.url
    assert_equal 120, v.duration
  end

  # AC-19: Only content_team_member can embed videos.
  # AC-20: Select an uploaded video from media library within post editor
  # AC-21: Selected video is correctly embedded
  # AC-22: Embedded videos play correctly
  test "content_team_member can associate a video with a post" do
    video = Video.create!(title: "Vid", url: "http://example.com/v", duration: 10, organization: @org, user: @user, post: @post)
    put "/api/#{@org.slug}/videos/#{video.id}", 
        params: { user_id: @user.id, post_id: @post.id }, 
        headers: auth_headers(@user), as: :json
    assert_response :success
    assert_equal @post.id, video.reload.post_id
  end

  test "outsider cannot associate a video with a post" do
    video = Video.create!(title: "Vid", url: "http://example.com/v", duration: 10, organization: @org, user: @user, post: @post)
    put "/api/#{@org.slug}/videos/#{video.id}", 
        params: { user_id: @user.id, post_id: @post.id }, 
        headers: auth_headers(@outsider), as: :json
    assert_response :forbidden
  end
end