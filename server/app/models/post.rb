# frozen_string_literal: true

class Post < Rhino::RhinoModel
  include Rhino::BelongsToOrganization
  include Discard::Model

  default_scope -> { kept }

  belongs_to :user, class_name: 'User'
  has_many :analytics_data, class_name: 'AnalyticsData'
  has_many :videos, class_name: 'Video'

  rhino_filters :user, :title, :status, :category, :read_time, :published_at
  rhino_sorts :user, :title, :status, :category, :read_time, :published_at, :created_at
  rhino_fields :id, :user, :user_id, :title, :content, :status, :category, :read_time, :published_at, :created_at, :views, :hasVideo, :videoDuration, :date

  def views
    analytics_data.where(event_type: 'view').count
  end

  def hasVideo
    videos.exists?
  end

  def videoDuration
    videos.sum(:duration)
  end

  def date
    published_at&.strftime('%Y-%m-%d')
  end
  rhino_includes :user
  validates :title, length: { maximum: 255 }, presence: true
  validates :status, length: { maximum: 255 }, presence: true
  validates :category, length: { maximum: 255 }, presence: true
  validates :read_time, numericality: { only_integer: true }, allow_nil: true

  def as_json(options = {})
    super(options).merge(
      'views' => views,
      'hasVideo' => hasVideo,
      'videoDuration' => videoDuration,
      'date' => date
    )
  end
end
