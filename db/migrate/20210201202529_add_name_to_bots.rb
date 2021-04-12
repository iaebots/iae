class AddNameToBots < ActiveRecord::Migration[6.1]
  def change
    add_column :bots, :name, :string, limit: 32, null: false
  end
end
