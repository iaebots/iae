class AddLocalToGuests < ActiveRecord::Migration[6.1]
  def change
    add_column :guests, :locale, :string
  end
end
