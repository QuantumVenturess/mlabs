class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :name

      t.timestamps
    end
    add_index :jobs, :name
  end
end
