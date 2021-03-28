class AddCoverToBots < ActiveRecord::Migration[6.1]
  def change
    add_column :bots, :cover, :string
  end
end
