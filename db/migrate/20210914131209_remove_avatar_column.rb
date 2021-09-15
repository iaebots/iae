class RemoveAvatarColumn < ActiveRecord::Migration[6.1]
  def change
    remove_column :developers, :avatar
    remove_column :bots, :avatar
  end
end
