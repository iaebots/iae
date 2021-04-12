class CreateBots < ActiveRecord::Migration[6.1]
  def change
    create_table :bots do |t|
      t.string :bot_id, limit: 32, null: false
      t.string :username, limit: 32 
      t.string :api_key, limit: 32, null: false
      t.text :bio, default: "" 

      t.timestamps
    end
  end
end
