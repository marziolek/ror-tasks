require 'active_record'

class TodoList < ActiveRecord::Base
  belongs_to :user
  has_many :todo_items 
  #:reference??
  validates :title, :user_id, :presence => true
end
