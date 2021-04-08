class AddBioToDevelopers < ActiveRecord::Migration[6.1]
  def change
    add_column :developers, :bio, :string
    add_column :developers, :verified, :boolean
    add_column :developers, :cover, :string
  end
end
