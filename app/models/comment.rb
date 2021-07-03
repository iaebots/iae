# frozen_string_literal: true

# Comment model
class Comment < ApplicationRecord
  belongs_to :commenter, polymorphic: true
  belongs_to :commentable, polymorphic: true

  has_many :likes, as: :likeable, dependent: :destroy

  self.per_page = 2

  validates_presence_of :body
  validates_length_of :body, maximum: 512, minimum: 1
end
