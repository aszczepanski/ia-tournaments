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

ActiveRecord::Schema.define(version: 20140605103554) do

  create_table "matches", force: true do |t|
    t.integer  "tournament_id"
    t.integer  "inner_id"
    t.integer  "left_user_id"
    t.integer  "left_user_winner_id"
    t.integer  "right_user_id"
    t.integer  "right_user_id_winner"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "matches", ["tournament_id", "inner_id"], name: "index_matches_on_tournament_id_and_inner_id", unique: true
  add_index "matches", ["tournament_id"], name: "index_matches_on_tournament_id"

  create_table "participations", force: true do |t|
    t.integer  "tournament_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_rank_position"
    t.integer  "user_license_id"
  end

  add_index "participations", ["tournament_id", "user_id"], name: "index_participations_on_tournament_id_and_user_id", unique: true
  add_index "participations", ["tournament_id", "user_license_id"], name: "index_participations_on_tournament_id_and_user_license_id", unique: true
  add_index "participations", ["tournament_id", "user_rank_position"], name: "index_participations_on_tournament_id_and_user_rank_position", unique: true
  add_index "participations", ["tournament_id"], name: "index_participations_on_tournament_id"
  add_index "participations", ["user_id"], name: "index_participations_on_user_id"

  create_table "sponsors", force: true do |t|
    t.integer  "tournament_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "name"
  end

  create_table "tournaments", force: true do |t|
    t.string   "name"
    t.integer  "organizer_id"
    t.datetime "date"
    t.datetime "deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "max_number_of_contestants", default: 0, null: false
    t.integer  "seeding_number",            default: 0, null: false
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "tournaments", ["organizer_id", "date"], name: "index_tournaments_on_organizer_id_and_date"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "forename",               default: "", null: false
    t.string   "surname",                default: "", null: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
