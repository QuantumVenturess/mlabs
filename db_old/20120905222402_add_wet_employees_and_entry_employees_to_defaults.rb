class AddWetEmployeesAndEntryEmployeesToDefaults < ActiveRecord::Migration
	def change
		add_column :defaults, :wet_employees, :integer
		add_index :defaults, :wet_employees
		add_column :defaults, :entry_employees, :integer
		add_index :defaults, :entry_employees
	end
end
