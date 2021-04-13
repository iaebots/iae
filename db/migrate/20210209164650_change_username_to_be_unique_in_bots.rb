class ChangeUsernameToBeUniqueInBots < ActiveRecord::Migration[6.1]
  def change
    change_column :bots, :username, :string, limit:32, unique: true, null: false
  end
end
