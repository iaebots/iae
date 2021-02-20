class Bot < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  belongs_to :developer

  acts_as_followable

  def timestamp
    created_at.strftime('%d %B %Y %H:%M')
  end
end
