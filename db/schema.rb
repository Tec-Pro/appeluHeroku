# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170226220509) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "businesses", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "status"
  end

  add_index "businesses", ["user_id"], name: "index_businesses_on_user_id", using: :btree

  create_table "customer_service_days", force: :cascade do |t|
    t.integer  "business_id"
    t.string   "day"
    t.time     "openingTime"
    t.time     "openingTime2"
    t.time     "closingTime"
    t.time     "closingTime2"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "customer_service_days", ["business_id"], name: "index_customer_service_days_on_business_id", using: :btree

  create_table "services", force: :cascade do |t|
    t.string   "name"
    t.integer  "duration"
    t.integer  "business_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "status"
  end

  add_index "services", ["business_id"], name: "index_services_on_business_id", using: :btree

  create_table "shifts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "service_id"
    t.string   "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "status"
  end

  add_index "shifts", ["service_id"], name: "index_shifts_on_service_id", using: :btree
  add_index "shifts", ["user_id"], name: "index_shifts_on_user_id", using: :btree

  create_table "tokens", force: :cascade do |t|
    t.datetime "expires_at"
    t.integer  "user_id"
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tokens", ["user_id"], name: "index_tokens_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
    t.string   "role"
    t.string   "password_hash"
    t.string   "password"
    t.boolean  "enable"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_foreign_key "businesses", "users"
  add_foreign_key "customer_service_days", "businesses"
  add_foreign_key "services", "businesses"
  add_foreign_key "shifts", "services"
  add_foreign_key "shifts", "users"
  add_foreign_key "tokens", "users"
end
