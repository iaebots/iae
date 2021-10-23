# frozen_string_literal: true

# Bot model
class Bot < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, as: :liker, dependent: :destroy
  has_many :comments, as: :commenter, dependent: :destroy

  belongs_to :developer

  acts_as_followable
  acts_as_taggable_on :tags

  include AvatarUploader::Attachment(:avatar)
  include CoverUploader::Attachment(:cover)

  validates_length_of :bio, minimum: 1, maximum: 512 # validates length of bot's bio

  # ensure bot's username doesn't contain symbols nor special characters
  validates_format_of :username, with: /\A[a-zA-Z0-9_-]*\z/
  validates_length_of :username, minimum: 3, maximum: 32

  validates_format_of :repository, with: %r{(http|https)://|[a-z0-9]+([\-.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(/.*)?/ix}

  # URL max value
  validates_length_of :repository, maximum: 64

  extend FriendlyId
  friendly_id :username, use: :slugged # username as friendly_id

  extend UsernamesBlocklist
  validates :friendly_id, exclusion: { in: blocklist }

  validate :validate_username, if: :username_changed?

  validate :tag_list_count

  before_save :downcase_username

  # remove all capitals from usernames
  def downcase_username
    username.downcase!
  end

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
    elsif Developer.where(username: username.downcase).exists?
      errors.add(:username, :already_taken)
    end
  end

  # Update user's friendly_id when username is changed
  def should_generate_new_friendly_id?
    username_changed?
  end

  # validates minimum and maximum number of tags and max tag length
  def tag_list_count
    errors.add(:tag_list, :minimum_tags) if tag_list.count < 1
    errors.add(:tag_list, :maximum_tags) if tag_list.count > 16

    tag_list.each do |tag|
      errors.add(:tag_list, :maximum_length, tag: tag) if tag.length > 32
      unless tag =~ /\A[a-zA-z][a-zA-Z0-9_-]*\z/
        errors.add(:tag_list, :invalid_format)
      end
      errors.add(:tag_list, :minimum_length, tag: tag) if tag.length < 2
    end
  end

  # Generate a unique API key
  def self.generate_api_key
    loop do
      token = SecureRandom.hex(16)
      break token unless Bot.exists?(api_key: token)
    end
  end

  # Generate a unique API secret
  def self.generate_api_secret
    loop do
      token = SecureRandom.hex(16)
      break token unless Bot.exists?(api_secret: token)
    end
  end
end
