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

ActiveRecord::Schema.define(version: 2018_06_08_140547) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "archetypes", force: :cascade do |t|
    t.jsonb "data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "replay_html_data", force: :cascade do |t|
    t.string "hsreplay_id", null: false
    t.text "data"
    t.jsonb "extracted_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hsreplay_id"], name: "index_replay_html_data_on_hsreplay_id", unique: true
  end

  create_table "replay_outcomes", force: :cascade do |t|
    t.string "hsreplay_id", null: false
    t.jsonb "data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_replay_outcomes_on_created_at", order: :desc
    t.index ["hsreplay_id"], name: "index_replay_outcomes_on_hsreplay_id", unique: true
  end

  create_table "replay_xml_data", force: :cascade do |t|
    t.string "hsreplay_id", null: false
    t.text "data"
    t.jsonb "extracted_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hsreplay_id"], name: "index_replay_xml_data_on_hsreplay_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "battletag", null: false
    t.string "uid", null: false
    t.string "region"
    t.jsonb "auth_hash", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["battletag"], name: "index_users_on_battletag", unique: true
  end

end
