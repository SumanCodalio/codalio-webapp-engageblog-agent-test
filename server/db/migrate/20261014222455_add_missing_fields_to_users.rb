class AddMissingFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :approved, :boolean
    add_column :users, :profile_completed, :boolean
  end
end
