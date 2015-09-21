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

ActiveRecord::Schema.define(version: 20150918133834) do

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

  add_index "competitors", ["active"], name: "index_competitors_on_active"
  add_index "competitors", ["name"], name: "index_competitors_on_name", unique: true

  create_table "games", force: :cascade do |t|
    t.string   "team"
    t.string   "teamA"
    t.string   "teamB"
    t.string   "map"
    t.string   "turns"
    t.string   "scoreA"
    t.string   "scoreB"
    t.string   "winner"
    t.string   "loser"
    t.string   "file"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "full_name_A"
    t.string   "full_name_B"
  end

  add_index "games", ["full_name_A", "full_name_B", "map"], name: "index_games_on_full_name_A_and_full_name_B_and_map", unique: true

  create_table "maps", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "maps", ["name"], name: "index_maps_on_name", unique: true

end
