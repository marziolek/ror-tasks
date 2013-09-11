class CreateTodoItems < ActiveRecord::Migration
  def change
    create_table :todo_items do |t|
      t.string :title
      t.text :description
      t.timestamp :date_due 
      t.integer :todo_list_id
    end
  end
end
