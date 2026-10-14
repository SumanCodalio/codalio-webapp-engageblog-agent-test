
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.rhino_owner(owner)
    @_rhino_owner = owner
  end

  def self.resource_owned_by
    @_rhino_owner || :organization
  end

  def self.owner_class
    Organization
  end
end

