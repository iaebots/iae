# frozen_string_literal: true

class RemoveMediaColumn < ActiveRecord::Migration[6.1]
  def change
    remove_column :posts, :media
  end
end
