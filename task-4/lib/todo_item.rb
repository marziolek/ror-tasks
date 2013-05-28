require 'active_record'

class TodoItem < ActiveRecord::Base
  belongs_to :todo_list

  validates :title, :todo_list_id,                  :presence => true
  validates :title,                                 :length => { :minimum => 5, :maximum => 30 }, :allow_blank => false
  validates :description,                           :length => { :maximum => 255 }, :allow_blank => true
  validates :date_due,                              :format => { :with => /^[0-9]{2}\/[0-9]{2}\/[0-9]{4}$/ }, :allow_blank => true
  validates :todo_list_id,                          :numericality => { :only_integer => true }
end
