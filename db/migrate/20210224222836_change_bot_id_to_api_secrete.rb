class ChangeBotIdToApiSecrete < ActiveRecord::Migration[6.1]
  def change
    rename_column :bots, :bot_id, :api_secret
  end
end
