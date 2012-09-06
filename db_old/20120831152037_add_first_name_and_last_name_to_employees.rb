class AddFirstNameAndLastNameToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :first_name, :string
    add_column :employees, :last_name, :string
    add_index :employees, [:first_name, :last_name], unique: true
  end
end
