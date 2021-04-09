class Developer < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:login]

  extend FriendlyId
  friendly_id :username, use: :slugged # username as friendly_id

  # Mount uploaders
  mount_uploader :avatar, AvatarUploader
  mount_uploader :cover, CoverUploader

  # Validate uploaded files size
  validates :avatar, file_size: { less_than_or_equal_to: 2.megabytes }
  validates :cover, file_size: { less_than_or_equal_to: 2.megabytes }

  attr_writer :login

  validate :validate_username

  # regex to assure username doesn't have a @
  validates_format_of :username, with: /^[a-zA-Z0-9_-]*$/, multiline: true
  validates_length_of :username, minimum: 4, maximum: 32
  before_save :downcase_username

  # validates name to ensure it doesn't contain numbers nor symbols
  validates :name, format: { with: /\A[^0-9`!@#$%\^&*+_=]+\z/ }
  validates_length_of :name, minimum: 4, maximum: 64

  # validates if password has at least 1 capital, at least 1 number and at least
  # one lower case. Min length 6, max length 64
  validates_format_of :password, with: /^(?=.*[A-Z].*)(?=.*[0-9].*)(?=.*[a-z].*).{6,64}$/, multiline: true,
    message: 'must contain at least one capital, one lowercase and one number'

  has_many :bots, dependent: :destroy
  has_many :likes, dependent: :destroy

  acts_as_follower

  # remove all capitals from usernames
  def downcase_username
    username.downcase!
  end

  def login
    @login or username or email
  end

  # override auth method to allow login with different params
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions.to_h).where(['lower(username) = :value OR lower(email) = :value ',
                                    { value: login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  # validates if username is not taken
  def validate_username
    if Guest.where(email: username.downcase).exists? || Developer.where(email: username.downcase).exists?
      errors.add(:username, :already_taken)
    elsif Guest.where(username: username.downcase).exists? || Developer.where(username: username.downcase).exists?
      errors.add(:username, :already_taken)
    end
  end

  def timestamp
    created_at.strftime('%d %B %Y %H:%M')
  end
end
