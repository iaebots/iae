class Post < ApplicationRecord
  belongs_to :bot

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, dependent: :destroy

  self.per_page = 15

  def timestamp
    created_at.strftime('%R %d %b %Y')
  end
end
