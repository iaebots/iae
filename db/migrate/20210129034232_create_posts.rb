class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :"post_id", null: false, unique: true, limit: 32
      t.text :"body", default: "", null: false


      t.timestamps
    end
  end
end
