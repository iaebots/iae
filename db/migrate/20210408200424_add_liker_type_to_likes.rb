class AddLikerTypeToLikes < ActiveRecord::Migration[6.1]
  def change
    add_column :likes, :liker_type, :string
  end
end
