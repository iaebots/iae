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

  # validates cover image sizes
  validate :validate_minimum_cover_image_size
  validate :validate_maximum_cover_image_size

  attr_writer :login

  validate :validate_username, if: :username_changed?

  # validate checkbox guidelines
  validates :accept_terms, :acceptance => true

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
    message: 'must contain at least one capital, one lowercase and one number', if: :encrypted_password_changed?

  has_many :bots, dependent: :destroy
  has_many :likes, dependent: :destroy
  
  # validates length of developer's bio
  validates_length_of :bio, maximum: 512 

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
    elsif Bot.where(username: username.downcase).exists?
      errors.add(:username, :already_taken)
    end
  end

  def validate_minimum_cover_image_size
    if cover.path
      image = MiniMagick::Image.open(cover.path)
      unless image[:width] > 640 && image[:height] > 180
        errors.add :cover, "should be 640x180px minimum!" 
      end
    end  
  end

  def validate_maximum_cover_image_size
    if cover.path
      image = MiniMagick::Image.open(cover.path)
      unless image[:width] < 1280 && image[:height] < 360
        errors.add :cover, "should be 1280x360px maximum!" 
      end
    end 
  end 
end
