class AddColumnsToReserves < ActiveRecord::Migration
  def change
  	add_column :reserves, :start_time, :datetime
  	add_column :reserves, :end_time, :datetime
  end
end
