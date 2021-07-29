# frozen_string_literal: true

class DropAcceptTerms < ActiveRecord::Migration[6.1]
  def change
    remove_column :developers, :accept_terms
  end
end
