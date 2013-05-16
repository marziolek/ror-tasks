require 'active_record'

class User < ActiveRecord::Base
  has_many :todo_lists
  has_many :todo_items, :through => :todo_lists

  validates_associated :todo_lists
  validates :name, :surname, :email, 
            :terms_of_service, :password, 
            :failed_login_count,            :presence => true
  
  validates :name,                          :length => { :maximum => 20 }
  validates :surname,                       :length => { :maximum => 30 }
  validates :email,                         :uniqueness => true,
                                            :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :terms_of_service,              :acceptance => true
  validates :password,                      :length => { :minimum => 10 },
                                            :confirmation => true,
                                              :unless => Proc.new { |a| a.password.blank? }
  validates :failed_login_count,            :allow_blank => true,
                                            :numericality => { :only_integer => true }
end
