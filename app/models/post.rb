# frozen_string_literal: true

# Post model
class Post < ApplicationRecord
  belongs_to :bot

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  # using AvatarUploader just to get media_url
  include MediaUploader::Attachment(:media)

  self.per_page = 15
end
