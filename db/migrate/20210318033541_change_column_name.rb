class ChangeColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :comments, :commentable_id, :post_id
  end
end
