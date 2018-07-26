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

ActiveRecord::Schema.define(version: 2018_07_26_083634) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "archetypes", force: :cascade do |t|
    t.jsonb "data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "forum_comments", force: :cascade do |t|
    t.integer "forum_post_id", null: false
    t.integer "user_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["forum_post_id"], name: "index_forum_comments_on_forum_post_id"
    t.index ["user_id"], name: "index_forum_comments_on_user_id"
  end

  create_table "forum_posts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title", null: false
    t.string "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "post_type"
    t.index ["user_id"], name: "index_forum_posts_on_user_id"
  end

  create_table "liked_replays", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "hsreplay_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "hsreplay_id"], name: "index_liked_replays_on_user_id_and_hsreplay_id", unique: true
  end

  create_table "replay_comments", force: :cascade do |t|
    t.string "hsreplay_id", null: false
    t.integer "user_id"
    t.text "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hsreplay_id", "user_id"], name: "index_replay_comments_on_hsreplay_id_and_user_id"
  end

  create_table "replay_game_api_responses", force: :cascade do |t|
    t.string "hsreplay_id", null: false
    t.jsonb "data", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "(((data -> 'global_game'::text) -> 'game_type'::text))", name: "index_replay_game_api_responses_on_game_type"
    t.index ["hsreplay_id"], name: "index_replay_game_api_responses_on_hsreplay_id", unique: true
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
    t.jsonb "extracted_data"
    t.index ["created_at"], name: "index_replay_outcomes_on_created_at", order: :desc
    t.index ["hsreplay_id"], name: "index_replay_outcomes_on_hsreplay_id", unique: true
  end

  create_table "replay_xml_data", force: :cascade do |t|
    t.string "hsreplay_id", null: false
    t.text "data"
    t.jsonb "extracted_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "played_at"
    t.integer "utc_offset"
    t.index ["hsreplay_id"], name: "index_replay_xml_data_on_hsreplay_id", unique: true
    t.index ["played_at"], name: "index_replay_xml_data_on_played_at"
  end

  create_table "submitted_replays", force: :cascade do |t|
    t.integer "user_id"
    t.string "hsreplay_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_submitted_replays", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "hsreplay_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "hsreplay_id"], name: "index_user_submitted_replays_on_user_id_and_hsreplay_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "battletag", null: false
    t.string "uid", null: false
    t.string "region"
    t.jsonb "auth_hash", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "twitch_username"
    t.string "forum_username"
    t.boolean "is_legend"
    t.index "lower((forum_username)::text)", name: "index_users_on_lowercase_forum_username", unique: true
    t.index ["battletag"], name: "index_users_on_battletag", unique: true
  end

  create_table "webhook_blobs", force: :cascade do |t|
    t.text "blob", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "converted_at"
  end

end
