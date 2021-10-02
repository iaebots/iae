# frozen_string_literal: true

class AddOrphanColumnToBots < ActiveRecord::Migration[6.1]
  def up
    add_column :bots, :orphan, :boolean, default: false
  end

  def down
    remove_column :bots, :orphan
  end
end
