# frozen_string_literal: true

class User < Rhino::RhinoModel
  has_secure_token :api_token

  include Rhino::HasPermissions

  has_secure_password

  has_many :user_roles, dependent: :destroy
  has_many :organizations, through: :user_roles
  has_many :roles, through: :user_roles

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  rhino_fields :id, :name, :email, :first_name, :last_name, :approved, :profile_completed
end
