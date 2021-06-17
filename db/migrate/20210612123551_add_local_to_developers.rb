class AddLocalToDevelopers < ActiveRecord::Migration[6.1]
  def change
    add_column :developers, :locale, :string
  end
end
