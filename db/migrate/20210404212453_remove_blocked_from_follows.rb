class RemoveBlockedFromFollows < ActiveRecord::Migration[6.1]
  def change
  	remove_column :follows, :blocked
  end
end
