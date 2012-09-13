class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :name
      t.text :content
      t.integer :employee_id
      t.integer :user_id

      t.timestamps
    end
    add_index :notes, :name
    add_index :notes, :employee_id
    add_index :notes, :user_id
  end
end
