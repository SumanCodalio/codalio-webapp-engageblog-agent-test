# frozen_string_literal: true

module Scopes
  class VideoScope < Rhino::ResourceScope
    # Custom query scope for Video.
    # Applied automatically to all Video queries via HasAutoScope.
    #
    # Available methods: user, organization, role
    #
    def apply(relation)
      relation
    end
  end
end
