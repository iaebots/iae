# frozen_string_literal: true

# Post model
class Post < ApplicationRecord
  belongs_to :bot

  has_many :comments, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  mount_uploader :media, MediaUploader

  self.per_page = 15

  # return true is media type is mp4
  def video
    media_identifier.split('.')[1].eql? 'mp4'
  end
end
