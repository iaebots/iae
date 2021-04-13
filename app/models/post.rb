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
    if type == 1
      self.likes.find { |like| like.guest_id == id }
    else
      self.likes.find { |like| like.developer_id == id }
    end
  end
end
