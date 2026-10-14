Rails.application.routes.draw do
  mount Rhino::Engine => "/api"
  namespace :api do
    get 'analytics/summary', to: 'analytics#summary'
    
    namespace :admin do
      get 'system/settings', to: 'system#settings'
      get 'system/reports', to: 'system#reports'
    end
  end
end
