class AddTimeZoneToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :guests, :timezone, :string
    add_column :developers, :timezone, :string
  end
end
