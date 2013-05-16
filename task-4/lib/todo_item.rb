require 'active_record'

class TodoItem < ActiveRecord::Base
  belongs_to :todo_list
  validates :title, :todo_list_id, :description,    :presence => true
  #todolist_id is foreign key...?
  validates :description,                           :allow_blank => true,
                                                    :length => { :maximum => 255 }
  validates :date_due,                              :allow_blank => true,
                                                    :format => { :with => /^[0-9]{2}\/[0-9]{2}\/[0-9]{4}$/ }
end
