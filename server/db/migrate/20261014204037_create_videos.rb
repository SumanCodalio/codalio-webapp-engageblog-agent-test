# frozen_string_literal: true

class CreateVideos < ActiveRecord::Migration[8.0]
  def change
    create_table :videos do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true
      t.string :title
      t.string :url
      t.integer :duration
      t.string :format
      t.integer :size
      t.string :resolution
      t.integer :bitrate
      t.string :thumbnail
      t.datetime :discarded_at
      t.index :discarded_at
      t.timestamps
    end
  end
end
