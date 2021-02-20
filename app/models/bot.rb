class Bot < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  belongs_to :developer

  acts_as_followable
end
