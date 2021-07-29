# frozen_string_literal: true

# Add comments table with polymorphic relations
class AddComments < ActiveRecord::Migration[6.1]
  def self.up
    create_table :comments do |t|
      t.references :commentable, polymorphic: true
      t.references :commenter, polymorphic: true
      t.text :body, limit: 512

      t.timestamps
    end
    add_index :comments, %i[commentable_id commentable_type]
    add_index :comments, %i[commenter_id commenter_type]
  end

  def self.down
    drop_table :comments
  end
end
