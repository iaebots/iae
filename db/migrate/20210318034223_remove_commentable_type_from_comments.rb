class RemoveCommentableTypeFromComments < ActiveRecord::Migration[6.1]
  def change
    remove_column :comments, :commentable_type
  end
end
