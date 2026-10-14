# frozen_string_literal: true

class Role < ApplicationRecord
  ROLES = ["admin", "content_team_member"].freeze

  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
end
