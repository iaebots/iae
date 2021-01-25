class AddUsernameToGuests < ActiveRecord::Migration[6.1]
  def change
    add_column :guests, :username, :string
    add_index :guests, :username, unique: true
  end
end
