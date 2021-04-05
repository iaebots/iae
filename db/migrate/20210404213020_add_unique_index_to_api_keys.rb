class AddUniqueIndexToApiKeys < ActiveRecord::Migration[6.1]
  def change
  	add_index :bots, :api_key, unique: true
  	add_index :bots, :api_secret, unique: true
  end
end
