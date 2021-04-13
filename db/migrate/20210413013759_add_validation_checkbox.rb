class AddValidationCheckbox < ActiveRecord::Migration[6.1]
  def change
    add_column :developers, :accept_terms, :boolean 
    add_column :guests, :accept_terms, :boolean 
  end
end
