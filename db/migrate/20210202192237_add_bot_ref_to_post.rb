class AddBotRefToPost < ActiveRecord::Migration[6.1]
  def change
    add_reference :posts, :bot, null: false, foreign_key: true
  end
end
