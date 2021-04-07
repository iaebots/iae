class AddRepositoryToBots < ActiveRecord::Migration[6.1]
  def change
    add_column :bots, :repository, :string
  end
end
