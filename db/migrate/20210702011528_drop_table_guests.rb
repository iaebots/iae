class DropTableGuests < ActiveRecord::Migration[6.1]
  def change
    drop_table :guests, force: :cascade
  end
end
