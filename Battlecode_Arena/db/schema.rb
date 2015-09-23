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

ActiveRecord::Schema.define(version: 20150923091856) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "competitors", force: :cascade do |t|
    t.string   "name"
    t.string   "team"
    t.integer  "Elo"
    t.boolean  "active"
    t.integer  "wins"
    t.integer  "losses"
    t.boolean  "broken"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "ai"
    t.string   "successor"
    t.integer  "submission"
    t.string   "full_name"
  end

  add_index "competitors", ["active"], name: "index_competitors_on_active", using: :btree
  add_index "competitors", ["name"], name: "index_competitors_on_name", unique: true, using: :btree

  create_table "games", force: :cascade do |t|
    t.string   "team"
    t.string   "teama"
    t.string   "teamb"
    t.string   "map"
    t.string   "turns"
    t.string   "scorea"
    t.string   "scoreb"
    t.string   "winner"
    t.string   "loser"
    t.string   "file"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "full_name_a"
    t.string   "full_name_b"
  end

  add_index "games", ["full_name_a", "full_name_b", "map"], name: "index_games_on_full_name_a_and_full_name_b_and_map", unique: true, using: :btree
  add_index "games", ["full_name_a"], name: "index_games_on_full_name_a", using: :btree
  add_index "games", ["full_name_b"], name: "index_games_on_full_name_b", using: :btree

  create_table "maps", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "maps", ["name"], name: "index_maps_on_name", unique: true, using: :btree

end
