class AddReferencesToLikes < ActiveRecord::Migration[6.1]
  def change
    remove_column :likes, :liker_id
    remove_column :likes, :liker_type
    add_reference :likes, :bot, foreign_key: true
    add_reference :likes, :guest, foreign_key: true
    add_reference :likes, :developer, foreign_key: true, null: true
  end
end
