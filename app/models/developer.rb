# frozen_string_literal: true

# Developer model
class Developer < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable, :lockable,
         :recoverable, :rememberable, :validatable, :timeoutable,
         authentication_keys: [:login]

  extend FriendlyId
  friendly_id :username, use: :slugged # username as friendly_id

  include AvatarUploader::Attachment(:avatar)
  include CoverUploader::Attachment(:cover)

  attr_writer :login

  extend UsernamesBlocklist
  validates :friendly_id, exclusion: { in: blocklist }

  validate :validate_username, if: :username_changed?

  # regex to assure username doesn't have a @
  validates_format_of :username, with: /\A[a-zA-Z0-9_-]*\z/
  validates_length_of :username, minimum: 4, maximum: 32
  before_save :downcase_username

  # validates name to ensure it doesn't contain numbers nor symbols
  validates :name, format: { with: /\A[^0-9`!@#$%^&*+_=]+\z/ }
  validates_length_of :name, minimum: 4, maximum: 64

  # validate password strength
  validates :password, password_strength: { min_entropy: 15, use_dictionary: true, min_word_length: 6 },
                       if: :encrypted_password_changed?

  has_many :bots
  has_many :likes, as: :liker
  has_many :comments, as: :commenter

  # validates length of developer's bio
  validates_length_of :bio, maximum: 512

  acts_as_follower

  # Save browser's locale as default user's preference locale
  before_create do |dev|
    dev.locale = I18n.locale
  end

  # remove all capitals from usernames
  def downcase_username
    username.downcase!
  end

  def login
    @login or username or email
  end

  # Update user's friendly_id when username is changed
  def should_generate_new_friendly_id?
    username_changed?
  end

  # instead of deleting, indicate the user requested a delete & timestamp it
  def soft_delete
    # set all bots as orphans
    bots.find_each do |bot|
      bot.update_attribute(:orphan, true)
    end
    update_attribute(:deleted_at, Time.current)
  end

  # ensure user account is active
  def active_for_authentication?
    super && !deleted_at
  end

  # provide a custom message for a deleted account
  def inactive_message
    !deleted_at ? super : :deleted_account
  end

  # override auth method to allow login with different params
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(['lower(username) = :value OR lower(email) = :value ',
                                    { value: login.downcase }]).first
    elsif conditions.key?(:username) || conditions.key?(:email)
      where(conditions.to_h).first
    end
  end

  # validates if username is not taken
  def validate_username
    if Developer.where(email: username.downcase).exists?
      errors.add(:username, :already_taken)
    elsif Developer.where(username: username.downcase).exists?
      errors.add(:username, :already_taken)
    elsif Bot.where(username: username.downcase).exists?
      errors.add(:username, :already_taken)
    end
  end

  # send emails in background
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
