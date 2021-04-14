class Bot < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  belongs_to :developer

  acts_as_followable
  acts_as_taggable_on :tags

  # Mount uploaders
  mount_uploader :avatar, AvatarUploader
  mount_uploader :cover, CoverUploader

  # Validate uploaded files size
  validates :avatar, file_size: { less_than_or_equal_to: 2.megabytes }
  validates :cover, file_size: { less_than_or_equal_to: 2.megabytes }

  validates_length_of :bio, minimum: 1, maximum: 512 # validates length of bot's bio

  # ensure bot's username doesn't contain symbols nor special characters
  validates_format_of :username, with: /^[a-zA-Z0-9_-]*$/, multiline: true
  validates_length_of :username, minimum: 4, maximum: 32

  extend FriendlyId
  friendly_id :username, use: :slugged # username as friendly_id

  validate :validate_username

  validate :tag_list_count

  # Assign an API key on create
  before_create do |bot|
    bot.api_key = bot.generate_api_key
    bot.api_secret = bot.generate_api_secret
  end

  # Generate a unique API key
  def generate_api_key
    loop do
      token = SecureRandom.hex(16)
      break token unless Bot.exists?(api_key: token)
    end
  end

  # Generate a unique API secret
  def generate_api_secret
    loop do
      token = SecureRandom.hex(16)
      break token unless Bot.exists?(api_secret: token)
    end
  end

  # validates if username is not taken
  def validate_username
    if Bot.where(username: username.downcase).exists?
      errors.add(:username, :already_taken)
    elsif Guest.where(username: username.downcase).exists? || Developer.where(username: username.downcase).exists? 
      errors.add(:username, :already_taken)
    end
  end

  # validates minimum and maximum number of tags and max tag length
  def tag_list_count 
    errors[:tag_list] << '1 tags minimum' if tag_list.count < 1
    errors[:tag_list] << '16 tags maximum' if tag_list.count > 16

    self.tag_list.each do |tag|
      errors[:tag_list] << "#{tag} must be shorter than 32 characters maximum" if tag.length > 32
      errors[:tag_list] << "must be named as variables" unless tag =~ /^[a-zA-z][a-zA-Z0-9_]*$/
      errors[:tag_list] << "#{tag} must be longer than 4 characters minimum" if tag.length < 4
    end
  end
end
