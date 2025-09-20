# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_09_20_235703) do
  create_table "observations", force: :cascade do |t|
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date_time"
    t.date "date"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "reservations_id", null: false
    t.integer "total_amount_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reservations_id"], name: "index_payments_on_reservations_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.string "customer_name"
    t.integer "total_amount_cents"
    t.integer "signal_amount_cents"
    t.datetime "entry_date_time"
    t.datetime "out_date_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "observation"
    t.integer "payment_status"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "payments", "reservations", column: "reservations_id"
end
