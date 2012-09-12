class AddMustAssignStationSeatToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :must_assign, :integer, default: 0
    add_column :employees, :station, :integer, default: 0
    add_column :employees, :seat, :integer, default: 0
    add_index :employees, :must_assign
    add_index :employees, :station
    add_index :employees, :seat
  end
end
