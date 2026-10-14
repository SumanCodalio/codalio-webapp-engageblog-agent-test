ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def create_organization(name = "Test Org", slug = "test-org-#{rand(10000)}")
      Organization.find_or_create_by!(slug: slug) { |o| o.name = name }
    end

    def create_role(slug, permissions)
      role = Role.find_or_create_by!(slug: slug) { |r| r.name = slug.titleize }
      role
    end

    def create_user(email: "test#{rand(10000)}@example.com", password: "password")
      User.create!(email: email, name: "Test User", password: password, password_confirmation: password)
    end

    def assign_role(user, org, role, permissions = [])
      UserRole.create!(user: user, organization: org, role: role)
      perm = OrgRolePermission.find_or_initialize_by(organization: org, role: role)
      perm.permissions = (perm.permissions || []) | permissions
      perm.save!
    end

    def auth_headers(user)
      { "Authorization" => "Bearer #{user.api_token}" }
    end
  end
end
