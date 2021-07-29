# frozen_string_literal: true

# Create table Votes with polymorphic associations
class CreateVotes < ActiveRecord::Migration[6.1]
  def self.up
    create_table :votes do |t|
      t.references :likeable, polymorphic: true
      t.references :liker, polymorphic: true

      t.timestamps
    end
    add_index :votes, %i[liker_id liker_type]
    add_index :votes, %i[likeable_id likeable_type]
  end

  def self.down
    drop_table :votes
  end
end
