class AddAssignToUndos < ActiveRecord::Migration
  def change
    add_column :undos, :sarah, :string
    add_column :undos, :qns, :string
    add_column :undos, :wones, :string
    add_column :undos, :entry, :string
    add_column :undos, :wet, :string
    add_index :undos, :sarah
    add_index :undos, :qns
    add_index :undos, :wones
    add_index :undos, :entry
    add_index :undos, :wet
  end
end
