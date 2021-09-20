class RemoveCoverColumnFromDevelopersAndBots < ActiveRecord::Migration[6.1]
  def change
    remove_column :developers, :cover
    remove_column :bots, :cover
  end
end
