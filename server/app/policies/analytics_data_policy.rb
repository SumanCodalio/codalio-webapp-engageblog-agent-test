# frozen_string_literal: true

class AnalyticsDataPolicy < Rhino::ResourcePolicy
  self.resource_slug = 'analytics_data'

def permitted_attributes_for_show(user)
  ['*']
end
def hidden_attributes_for_show(user)
  []
end
def permitted_attributes_for_create(user)
  ['*']
end
def permitted_attributes_for_update(user)
  ['*']
end
end
