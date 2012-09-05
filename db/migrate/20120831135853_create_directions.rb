class CreateDirections < ActiveRecord::Migration
  def change
    create_table :directions do |t|
      t.integer :employee_id
      t.integer :location_id

      t.timestamps
    end
    add_index :directions, [:employee_id, :location_id]
  end
end
