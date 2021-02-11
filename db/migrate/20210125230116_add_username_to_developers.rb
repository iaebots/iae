class AddUsernameToDevelopers < ActiveRecord::Migration[6.1]
  def change
    add_column :developers, :username, :string
    add_index :developers, :username, unique: true
  end
end
