class Api::AnalyticsController < ApplicationController
  before_action :authenticate_request!

  def summary
    org = RequestStore.store[:rhino_organization] || Organization.first
    total_views = AnalyticsData.where(organization: org, event_type: 'view').count
    avg_engagement_rate = 5.4 # Mocked for MVP
    
    render json: {
      totalReach: total_views,
      avgEngagementRate: avg_engagement_rate,
      viewsByDate: [
        { date: '2023-10-20', views: 100 },
        { date: '2023-10-21', views: 150 }
      ]
    }
  end

  private

  def authenticate_request!
    # Mock auth for custom endpoint, in real Rhino it's handled by middleware
  end
end
