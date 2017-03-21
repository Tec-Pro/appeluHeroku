class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :provider
      t.string :uid
      t.string :role
      t.string :password_hash
      t.string :password
      t.boolean :enable 
      
      t.timestamps null: false
    end
  end
end