class AddStatusToReserve < ActiveRecord::Migration
  def change
  	remove_column :reserves, :enable
  	add_column :reserves, :status, :string
  end
end
