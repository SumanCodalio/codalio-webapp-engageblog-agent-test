# frozen_string_literal: true

class CreateAnalyticsData < ActiveRecord::Migration[8.0]
  def change
    create_table :analytics_data do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :post, foreign_key: true
      t.string :event_type
      t.json :event_data
      t.datetime :recorded_at
      t.datetime :discarded_at
      t.index :discarded_at
      t.timestamps
    end
  end
end
