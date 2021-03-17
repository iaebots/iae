class AddSlugToBots < ActiveRecord::Migration[6.1]
  def change
    add_column :bots, :slug, :string
    add_index :bots, :slug, unique: true
  end
end
