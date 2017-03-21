class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :name
      t.references :user, index: true
      t.boolean :enable

      t.timestamps null: false
    end
    add_foreign_key :businesses, :users
  end
end
