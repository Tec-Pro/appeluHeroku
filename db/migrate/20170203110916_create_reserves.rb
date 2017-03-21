class CreateReserves < ActiveRecord::Migration
  def change
    create_table :reserves do |t|
      t.references :user, index: true
      t.references :service, index: true
      t.boolean :enable
      t.string :comment
      t.timestamps :startTime
      t.timestamps :endTime

      t.timestamps null: false
    end
    add_foreign_key :reserves, :users
    add_foreign_key :reserves, :services
  end
end
