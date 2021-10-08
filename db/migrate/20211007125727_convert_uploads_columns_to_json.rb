# frozen_string_literal: true

# Convert all columns that contains "upload_data" to JSON
class ConvertUploadsColumnsToJson < ActiveRecord::Migration[6.1]
  def up
    change_column :bots, :avatar_data, :jsonb, using: 'avatar_data::JSON'
    change_column :bots, :cover_data, :jsonb, using: 'cover_data::JSON'
    change_column :developers, :avatar_data, :jsonb, using: 'avatar_data::JSON'
    change_column :developers, :cover_data, :jsonb, using: 'cover_data::JSON'
    change_column :posts, :media_data, :jsonb, using: 'media_data::JSON'
  end

  def down
    change_column :bots, :avatar_data, :text
    change_column :developers, :avatar_data, :text
    change_column :bots, :cover_data, :text
    change_column :developers, :cover_data, :text
    change_column :posts, :media_data, :text
  end
end
