class CreateTodoitems < ActiveRecord::Migration
  def change
    create_table :todoitems do |t|
      t.string :title
      t.string :description
      t.string :date_due
      t.string :todo_list_id
    end
  end
end
