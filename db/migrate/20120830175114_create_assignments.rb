class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :employee_id
      t.integer :job_id

      t.timestamps
    end
    add_index :assignments, [:employee_id, :job_id]
  end
end
