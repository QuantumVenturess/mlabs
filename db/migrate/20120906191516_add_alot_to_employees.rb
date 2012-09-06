class AddAlotToEmployees < ActiveRecord::Migration
  def change
  	add_column :employees, :floater, :boolean, default: false
  	add_column :employees, :wones_team, :boolean, default: false
  	add_column :employees, :wones_worked, :boolean, default: false
  	add_column :employees, :qns_team, :boolean, default: false
  	add_column :employees, :qns_worked, :boolean, default: false
  	add_column :employees, :sarah_team, :boolean, default: false
  	add_column :employees, :sarah_worked, :boolean, default: false
  	add_index :employees, :vacation
  	add_index :employees, :floater
  	add_index :employees, :wones_team
  	add_index :employees, :wones_worked
  	add_index :employees, :qns_team
  	add_index :employees, :qns_worked
  	add_index :employees, :sarah_team
  	add_index :employees, :sarah_worked
  end
end
