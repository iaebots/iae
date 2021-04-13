class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.integer :commentable_id
      t.string :commentable_type
      t.references :bot, null: false, foreign_key: true
      t.boolean :reply, default: false

      t.timestamps
    end
  end
end
