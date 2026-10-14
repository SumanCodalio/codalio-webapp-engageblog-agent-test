# Multi-tenant setup
demo_org = Organization.find_or_create_by!(slug: 'demo-org') do |o|
  o.name = 'Demo Organization'
end

other_org = Organization.find_or_create_by!(slug: 'runtime-other-org') do |o|
  o.name = 'Runtime Other Organization'
end

admin_role = Role.find_or_create_by!(slug: 'admin') do |r|
  r.name = 'Admin'
end

viewer_role = Role.find_or_create_by!(slug: 'viewer') do |r|
  r.name = 'Viewer'
end

OrgRolePermission.find_or_create_by!(organization: demo_org, role: admin_role) do |p|
  p.permissions = [
    "posts.index", "posts.show", "posts.store", "posts.update", "posts.destroy",
    "videos.index", "videos.show", "videos.store", "videos.update", "videos.destroy",
    "analytics_data.index", "analytics_data.show", "analytics_data.store", "analytics_data.update", "analytics_data.destroy",
    "users.index", "users.show", "users.store", "users.update", "users.destroy"
  ]
end

OrgRolePermission.find_or_create_by!(organization: demo_org, role: viewer_role) do |p|
  p.permissions = [
    "posts.index", "posts.show",
    "videos.index", "videos.show",
    "analytics_data.index", "analytics_data.show"
  ]
end

OrgRolePermission.find_or_create_by!(organization: other_org, role: admin_role) do |p|
  p.permissions = [
    "posts.index", "posts.show", "posts.store", "posts.update", "posts.destroy",
    "videos.index", "videos.show", "videos.store", "videos.update", "videos.destroy",
    "analytics_data.index", "analytics_data.show", "analytics_data.store", "analytics_data.update", "analytics_data.destroy",
    "users.index", "users.show", "users.store", "users.update", "users.destroy"
  ]
end

admin = User.find_or_create_by!(email: 'administrator@example.com') do |u|
  u.name = 'Admin User'
  u.password = 'password'
  u.password_confirmation = 'password'
end

UserRole.find_or_create_by!(user: admin, organization: demo_org) do |ur|
  ur.role = admin_role
end

viewer = User.find_or_create_by!(email: 'viewer@example.com') do |u|
  u.name = 'Viewer User'
  u.password = 'password'
  u.password_confirmation = 'password'
end

UserRole.find_or_create_by!(user: viewer, organization: demo_org) do |ur|
  ur.role = viewer_role
end

outsider = User.find_or_create_by!(email: 'outsider@example.com') do |u|
  u.name = 'Outsider User'
  u.password = 'password'
  u.password_confirmation = 'password'
end

UserRole.find_or_create_by!(user: outsider, organization: other_org) do |ur|
  ur.role = admin_role
end

# Seed a representative record for the selected tenant resource
Post.find_or_create_by!(title: 'Welcome to Demo Org', organization: demo_org) do |p|
  p.user = admin
  p.content = 'This is a demo post.'
  p.status = 'published'
  p.category = 'general'
  p.published_at = Time.current
end

Post.find_or_create_by!(title: 'Welcome to Other Org', organization: other_org) do |p|
  p.user = outsider
  p.content = 'This is another post.'
  p.status = 'published'
  p.category = 'general'
  p.published_at = Time.current
end

puts "Database seeded successfully!"
