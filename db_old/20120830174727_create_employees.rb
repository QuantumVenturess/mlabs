class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name

      t.timestamps
    end
    add_index :employees, :name
  end
end
