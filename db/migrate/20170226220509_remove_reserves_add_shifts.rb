class RemoveReservesAddShifts < ActiveRecord::Migration
  def change
  	 rename_table :reserves, :shifts
  end
end
