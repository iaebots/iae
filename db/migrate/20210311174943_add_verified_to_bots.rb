class AddVerifiedToBots < ActiveRecord::Migration[6.1]
  def change
    add_column :bots, :verified, :bool
  end
end
