class MakeBotsUsernameUnique < ActiveRecord::Migration[6.1]
  def change
    add_index :bots, :username, unique: true
  end
end
