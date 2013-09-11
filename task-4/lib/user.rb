require 'active_record'
require 'bcrypt'

class User < ActiveRecord::Base
#  attr_accessor :terms_of_service
  include BCrypt
  
  before_validation :set_encrypted_password

  has_many :todo_lists
  has_many :todo_items, :through => :todo_lists
  
  validates_associated :todo_lists
  validates  :name, :surname, :email, 
            :password, 
            :failed_login_count,            :presence => true
  
  validates :name,                          :length => { :maximum => 20 }
  validates :surname,                       :length => { :maximum => 30 }
  validates :email,                         :uniqueness => true,
                                            :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :terms_of_service,              :acceptance => { :accept => true }, 
                                            :allow_nil => false
  validates :password,                      :length => { :minimum => 10 },
                                            :confirmation => true,
                                            :unless => Proc.new { |a| a.password.blank? }
  validates :failed_login_count,            :numericality => { :only_integer => true }
  
  #attr_accessible :name, :surname, :email, :password, :failed_login_count
  attr_accessor :password, :password_confirmation

  def self.find_by_name(name)
    where("name = ?", name)
  end

  def self.find_by_email(email)
    where("email = ?", email).first
  end

  def find_suspicious
    User.where("failed_login_count > 2").order("failed_login_count DESC").all
  end
  
  def encrypted_password
    Password.new(super)
  end

  def encrypted_password=(new_password)
    super(Password.create(new_password))
  end
  
  def authenticate
    user = User.find_by_email(email)
    user && user.encrypted_password == password
  end
  
  private
  def set_encrypted_password
    self.encrypted_password = password
  end
end
