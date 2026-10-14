# frozen_string_literal: true

module Scopes
  class PostScope < Rhino::ResourceScope
    # Custom query scope for Post.
    # Applied automatically to all Post queries via HasAutoScope.
    #
    # Available methods: user, organization, role
    #
    def apply(relation)
      relation
    end
  end
end
