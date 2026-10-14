# frozen_string_literal: true

class Video < Rhino::RhinoModel
  include Rhino::BelongsToOrganization
  include Discard::Model

  default_scope -> { kept }

  belongs_to :user, class_name: 'User'
  belongs_to :post, class_name: 'Post'

  rhino_filters :user, :post, :title, :url, :duration, :format, :size, :resolution, :bitrate, :thumbnail
  rhino_sorts :user, :post, :title, :url, :duration, :format, :size, :resolution, :bitrate, :thumbnail, :created_at
  rhino_fields :id, :user, :post, :title, :url, :duration, :format, :size, :resolution, :bitrate, :thumbnail, :created_at
  rhino_includes :user, :post
  validates :title, length: { maximum: 255 }, allow_nil: true
  validates :url, length: { maximum: 255 }, allow_nil: true
  validates :duration, numericality: { only_integer: true }, allow_nil: true
  validates :format, length: { maximum: 255 }, allow_nil: true
  validates :size, numericality: { only_integer: true }, allow_nil: true
  validates :resolution, length: { maximum: 255 }, allow_nil: true
  validates :bitrate, numericality: { only_integer: true }, allow_nil: true
  validates :thumbnail, length: { maximum: 255 }, allow_nil: true
end
