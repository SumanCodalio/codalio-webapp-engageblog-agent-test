class Api::Admin::SystemController < ApplicationController
  def settings
    render json: {
      maintenanceMode: false,
      maxUploadSize: '1GB',
      autoBackup: true
    }
  end

  def reports
    render json: {
      uptime: '99.9%',
      activeUsers: User.count,
      totalStorage: '50GB'
    }
  end
end
