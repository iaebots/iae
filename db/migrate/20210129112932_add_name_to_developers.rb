class AddNameToDevelopers < ActiveRecord::Migration[6.1]
  def change
    add_column :developers, :name, :string, null: false, default: ""
  end
end
