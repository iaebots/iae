class AddAvatarToBots < ActiveRecord::Migration[6.1]
  def change
    add_column :bots, :avatar, :string
  end
end
