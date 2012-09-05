class RemoveColumnsAndAddColumnsToEmployee < ActiveRecord::Migration
	def change
		remove_index :employees, name: "index_employees_on_daily_worked"
		remove_column :employees, :daily_worked

		add_column :employees, :tier, :integer, default: 0
		add_index :employees, :tier
		
		add_column :employees, :wet_worked, :boolean, default: false
		add_index :employees, :wet_worked

		add_column :employees, :entry_worked, :boolean, default: false
		add_index :employees, :entry_worked
	end
end
