class RemoveColumns < ActiveRecord::Migration
  def change
  	remove_column :businesses, :enable
  	add_column :businesses, :status, :string
  	remove_column :services, :enable
  	add_column :services, :status, :string
  end
end
