require 'active_record'

class TodoList < ActiveRecord::Base
  #:reference??
  validates :title, :user_id,       :presence => true
end
