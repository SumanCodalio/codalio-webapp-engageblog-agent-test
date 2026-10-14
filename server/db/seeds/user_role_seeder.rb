# frozen_string_literal: true


org = Organization.find_or_create_by!(slug: 'demo-org') do |o|
  o.name = 'Demo Organization'
end

# Admin
admin_user = User.find_or_create_by!(email: 'admin@demo.com') do |u|
  u.password = 'password'
end
admin_role = Role.find_by!(slug: 'admin')
UserRole.find_or_create_by!(
  user: admin_user,
  organization: org,
  role: admin_role
) do |ur|
  ur.permissions = [
        'analytics_data.destroy',
        'analytics_data.index',
        'analytics_data.show',
        'analytics_data.store',
        'analytics_data.update',
        'posts.destroy',
        'posts.index',
        'posts.show',
        'posts.store',
        'posts.update',
        'videos.destroy',
        'videos.index',
        'videos.show',
        'videos.store',
        'videos.update',
      ]
end

# Content Team Member
content_team_member_user = User.find_or_create_by!(email: 'content_team_member@demo.com') do |u|
  u.password = 'password'
end
content_team_member_role = Role.find_by!(slug: 'content_team_member')
UserRole.find_or_create_by!(
  user: content_team_member_user,
  organization: org,
  role: content_team_member_role
) do |ur|
  ur.permissions = [
        'analytics_data.destroy',
        'analytics_data.index',
        'analytics_data.show',
        'analytics_data.store',
        'analytics_data.update',
        'posts.destroy',
        'posts.index',
        'posts.show',
        'posts.store',
        'posts.update',
        'videos.destroy',
        'videos.index',
        'videos.show',
        'videos.store',
        'videos.update',
      ]
end
