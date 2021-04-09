class Like < ApplicationRecord
  belongs_to :post
  belongs_to :bot, optional: true
  belongs_to :developer, optional: true
  belongs_to :guest, optional: true
end
