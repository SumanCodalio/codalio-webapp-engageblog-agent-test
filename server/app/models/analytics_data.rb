# frozen_string_literal: true

class AnalyticsData < Rhino::RhinoModel
  include Rhino::BelongsToOrganization
  include Discard::Model

  default_scope -> { kept }

  belongs_to :post, class_name: 'Post'

  rhino_filters :post, :event_type, :recorded_at
  rhino_sorts :post, :event_type, :recorded_at, :created_at
  rhino_fields :id, :post, :event_type, :event_data, :recorded_at, :created_at
  rhino_includes :post
  validates :event_type, length: { maximum: 255 }, allow_nil: true
end
