# frozen_string_literal: true

class SetVerifiedDefaultValue < ActiveRecord::Migration[6.1]
  def up
  	change_column_default :bots, :verified, false
  	change_column_default :developers, :verified, false
  end

  def down
  	change_column_default :bots, :verified, nil
  	change_column_default :developers, :verified, nil
  end
end
