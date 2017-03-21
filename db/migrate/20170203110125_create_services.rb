class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name
      t.integer :duration
      t.boolean :enable
      t.references :business, index: true

      t.timestamps null: false
    end
    add_foreign_key :services, :businesses
  end
end
