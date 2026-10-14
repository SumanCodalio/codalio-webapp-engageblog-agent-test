Rails.application.config.to_prepare do
  Rhino::ResourcesController.rescue_from(ActiveRecord::RecordInvalid) do |e|
    render json: { errors: e.record.errors.to_hash }, status: :unprocessable_entity
  end
end
