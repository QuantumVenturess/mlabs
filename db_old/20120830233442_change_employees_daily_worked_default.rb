class ChangeEmployeesDailyWorkedDefault < ActiveRecord::Migration
 	def change
 		remove_index :employees, name: "index_employees_on_worked"
 		add_index :employees, :daily_worked
 	end
end
