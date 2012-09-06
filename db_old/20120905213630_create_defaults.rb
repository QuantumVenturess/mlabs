class CreateDefaults < ActiveRecord::Migration
  def change
    create_table :defaults do |t|
      t.integer :lab_employees
      t.integer :work_days

      t.timestamps
    end
    add_index :defaults, :lab_employees
    add_index :defaults, :work_days
  end
end
