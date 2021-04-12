class RemoveCommentabletypeFromComments < ActiveRecord::Migration[6.1]
  def change
    remove_column :comments, :reply
  end
end
