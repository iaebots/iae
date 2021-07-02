class Post < ApplicationRecord
  belongs_to :bot

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  mount_uploader :media, MediaUploader

  self.per_page = 15

  # return true is media type is mp4
  def video
    media_identifier.split('.')[1].eql? 'mp4'
  end

  # checks if post has been liked by current user
  def liked?(id, type)
    likes.find { |like| like.developer_id == id } if type == 2
  end
end
