class AddImageDataColumnsForShrine < ActiveRecord::Migration[6.1]
  def change
    add_column :developers, :avatar_data, :text
    add_column :developers, :cover_data, :text
    add_column :bots, :avatar_data, :text
    add_column :bots, :cover_data, :text
    add_column :posts, :media_data, :text
  end
end
