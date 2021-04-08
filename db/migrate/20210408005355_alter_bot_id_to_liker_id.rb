class AlterBotIdToLikerId < ActiveRecord::Migration[6.1]
  def change
    rename_column :likes, :bot_id, :liker_id
    #Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
