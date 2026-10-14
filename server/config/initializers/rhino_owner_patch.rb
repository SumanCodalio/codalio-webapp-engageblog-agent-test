
module RhinoModelPatch
  extend ActiveSupport::Concern
  class_methods do
    def rhino_owner(owner)
      @_rhino_owner = owner
    end
    def resource_owned_by
      @_rhino_owner || :organization
    end
    def owner_class
      Organization
    end
  end
end
ActiveRecord::Base.include(RhinoModelPatch)

