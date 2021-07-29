# frozen_string_literal: true

class AlterVotesToLikes < ActiveRecord::Migration[6.1]
  def self.up
    rename_table :votes, :likes
  end

  def self.down
    rename_table :likes, :votes
  end
end
