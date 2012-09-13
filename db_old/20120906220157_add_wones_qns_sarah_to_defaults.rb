class AddWonesQnsSarahToDefaults < ActiveRecord::Migration
  def change
    add_column :defaults, :wones_employees, :integer
    add_column :defaults, :qns_employees, :integer
    add_column :defaults, :sarah_employees, :integer
    add_index :defaults, :wones_employees
    add_index :defaults, :qns_employees
    add_index :defaults, :sarah_employees
  end
end
