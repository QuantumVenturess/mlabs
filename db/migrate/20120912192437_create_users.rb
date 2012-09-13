class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :encrypted_password
      t.string :salt
      t.boolean :admin, default: false
      t.string :slug
      t.datetime :last_signed_in
      t.integer :sign_in_count

      t.timestamps
    end
    add_index :users, :name, unique: true
    add_index :users, :email, unique: true
    add_index :users, :slug
    add_index :users, :last_signed_in
    add_index :users, :sign_in_count
  end
end
