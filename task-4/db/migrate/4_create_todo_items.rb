class CreateTodoItems < ActiveRecord::Migration
  def change
    create_table :todo_items do |t|
      t.string :title
      t.text :description
      t.date :date_due #dunno if its good format dd/mm/yyyy
      t.integer :todo_list_id
    end
  end
end
