class CreateTodolists < ActiveRecord::Migration
  def change
    create_table :todolists do |t|
      t.string :tilte
      t.string :user_id
    end
  end
end
