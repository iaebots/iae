class Post < ApplicationRecord
  belongs_to :bot

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  mount_uploader :media, MediaUploader

  self.per_page = 15

  def timestamp
    created_at.strftime('%R %d %b %Y')
  end

  # return true is media type is mp4
  def video
    media_identifier.split('.')[1].eql? 'mp4'
  end

  def liked?(id)
    self.likes.find { |like| like.liker_id == id }
  end
end
