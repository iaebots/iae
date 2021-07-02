# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :post
  belongs_to :bot, optional: true
  belongs_to :developer, optional: true
end
