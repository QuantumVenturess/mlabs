class ChangeEmployeesWorkedTypeToString < ActiveRecord::Migration
	def change
		rename_column :employees, :worked, :daily_worked
#		change_column :employees, :daily_worked, :boolean
	end
end
