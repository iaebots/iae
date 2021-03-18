class AddAvatarToDevelopers < ActiveRecord::Migration[6.1]
  def change
    add_column :developers, :avatar, :string
  end
end
