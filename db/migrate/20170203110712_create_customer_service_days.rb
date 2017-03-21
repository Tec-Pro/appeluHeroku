class CreateCustomerServiceDays < ActiveRecord::Migration
  def change
    create_table :customer_service_days do |t|
      t.references :business, index: true
      t.string :day
      t.time :openingTime
      t.time :openingTime2
      t.time :closingTime
      t.time :closingTime2

      t.timestamps null: false
    end
    add_foreign_key :customer_service_days, :businesses
  end
end
