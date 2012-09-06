class AddVacationToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :vacation, :boolean, default: false
  end
end
