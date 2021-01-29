class Guest < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, authentication_keys: [:login]

  attr_writer :login
  validate :validate_username
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true
  before_save :downcase_username

  # evita letras maisúculas em nomes de usuários
  def downcase_username
    self.username.downcase!
  end
         
  def login
    @login or self.username or self.email     
  end  
       
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value ", {:value => login.downcase}]).first
      elsif conditions.has_key?(:username) or conditions.has_key?(:email)
        where(conditions.to_h).first
      end 
  end
       
  def validate_username
    if Guest.where(email: username.downcase).exists? or Developer.where(email: username.downcase).exists?
      errors.add(:username, :invalid)
    elsif Guest.where(username: username.downcase).exists? or Developer.where(username: username.downcase).exists?
      errors.add(:username, :invalid) 
    end
  end
end
