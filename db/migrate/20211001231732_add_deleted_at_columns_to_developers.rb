# frozen_string_literal: true

class AddDeletedAtColumnsToDevelopers < ActiveRecord::Migration[6.1]
  def up
    add_column :developers, :deleted_at, :datetime
  end

  def down
    remove_column :developers, :deleted_at
  end
end
