require 'active_record'

class TodoItem < ActiveRecord::Base
  validates :title,          :presence => true
  validates :todolist_id,    :presence => true

end
