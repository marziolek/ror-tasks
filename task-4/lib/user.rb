require 'active_record'

class User < ActiveRecord::Base
#  attr_accessor :terms_of_service

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
  validates :terms_of_service,              :acceptance => { :accept => "yes" }
  validates :password,                      :length => { :minimum => 10 },
                                            :confirmation => true,
                                            :unless => Proc.new { |a| a.password.blank? }
  validates :failed_login_count,            :numericality => { :only_integer => true }

  def find_by_name(name)
    User.where("name = ?", name)
  end

  def find_by_email(email)
    User.where("email = ?", email)
  end

  def find_suspicious
    User.where("failed_login_count > 2").all
  end
end
