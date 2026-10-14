require "test_helper"

class PostTest < ActiveSupport::TestCase
  # AC-14: Virtual attributes
  test "virtual attributes are calculated correctly" do
    org = Organization.create!(name: "Test Org", slug: "test-org")
    user = User.create!(name: "Test", email: "test@example.com", password: "password")
    post = Post.create!(title: "Test Post", status: "published", category: "general", organization: org, user: user, published_at: Time.zone.parse('2023-10-20'))
    
    assert_equal 0, post.views
    assert_equal false, post.hasVideo
    assert_equal 0, post.videoDuration
    assert_equal "2023-10-20", post.date
  end
end
