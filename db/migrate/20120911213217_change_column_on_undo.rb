class ChangeColumnOnUndo < ActiveRecord::Migration
  def change
  	change_column :undos, :sarah, :text
  	change_column :undos, :qns, :text
  	change_column :undos, :wones, :text
  	change_column :undos, :entry, :text
  	change_column :undos, :wet, :text
  end
end
