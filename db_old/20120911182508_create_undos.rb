class CreateUndos < ActiveRecord::Migration
  def change
    create_table :undos do |t|
      t.string :name

      t.timestamps
    end
    add_index :undos, :name
  end
end
