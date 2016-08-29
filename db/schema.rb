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

ActiveRecord::Schema.define(version: 20160829093358) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "background_jobs", force: :cascade do |t|
    t.date    "start_date",       default: '2016-08-29', null: false
    t.integer "period"
    t.integer "completed"
    t.integer "base_currency_id"
    t.integer "exchange_id"
    t.index ["base_currency_id"], name: "index_background_jobs_on_base_currency_id", using: :btree
    t.index ["exchange_id"], name: "index_background_jobs_on_exchange_id", using: :btree
  end

  create_table "currencies", force: :cascade do |t|
    t.string   "code"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_currencies_on_code", unique: true, using: :btree
  end

  create_table "exchanges", force: :cascade do |t|
    t.integer "amount"
    t.integer "period"
    t.date    "request_date",       default: '2016-08-28', null: false
    t.integer "user_id"
    t.integer "base_currency_id"
    t.integer "target_currency_id"
    t.index ["base_currency_id"], name: "index_exchanges_on_base_currency_id", using: :btree
    t.index ["target_currency_id"], name: "index_exchanges_on_target_currency_id", using: :btree
    t.index ["user_id"], name: "index_exchanges_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "weekly_rates", force: :cascade do |t|
    t.date     "rate_date"
    t.float    "rate"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "base_currency_id"
    t.integer  "target_currency_id"
    t.index ["base_currency_id"], name: "index_weekly_rates_on_base_currency_id", using: :btree
    t.index ["target_currency_id"], name: "index_weekly_rates_on_target_currency_id", using: :btree
  end

end
