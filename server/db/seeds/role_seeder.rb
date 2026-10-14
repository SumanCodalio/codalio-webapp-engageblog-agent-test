# frozen_string_literal: true


Role.find_or_create_by!(slug: 'admin') do |r|
  r.name = 'Admin'
  r.description = ''
end

Role.find_or_create_by!(slug: 'content_team_member') do |r|
  r.name = 'Content Team Member'
  r.description = ''
end
