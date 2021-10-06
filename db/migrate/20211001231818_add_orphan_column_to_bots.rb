# frozen_string_literal: true

class AddOrphanColumnToBots < ActiveRecord::Migration[6.1]
  def up
    add_column :bots, :is_orphan, :boolean, default: false
  end

  def down
    remove_column :bots, :is_orphan
  end
end
