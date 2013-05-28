require 'active_record'

class TodoList < ActiveRecord::Base
  belongs_to :user
  has_many :todo_items 
  
  validates :title, :user_id, :presence => true
  validates :user_id,         :numericality => { :only_integer => true }
  validates_associated :todo_items  
end
