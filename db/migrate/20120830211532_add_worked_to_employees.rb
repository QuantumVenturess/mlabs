class AddWorkedToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :worked, :integer
    add_index :employees, :worked
  end
end
