# frozen_string_literal: true

module Scopes
  class AnalyticsDataScope < Rhino::ResourceScope
    # Custom query scope for AnalyticsData.
    # Applied automatically to all AnalyticsData queries via HasAutoScope.
    #
    # Available methods: user, organization, role
    #
    def apply(relation)
      relation
    end
  end
end
