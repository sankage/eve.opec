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

ActiveRecord::Schema.define(version: 20150922055933) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "moons", force: :cascade do |t|
    t.integer  "item_id"
    t.string   "name"
    t.integer  "planet"
    t.integer  "orbit"
    t.integer  "system_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "moons", ["system_id"], name: "index_moons_on_system_id", using: :btree

  create_table "pilots", force: :cascade do |t|
    t.integer  "character_id"
    t.string   "name"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "admin",        default: false
  end

  create_table "static_map_denormalizes", force: :cascade do |t|
    t.integer "item_id",          limit: 8
    t.integer "type_id"
    t.integer "group_id"
    t.integer "solar_system_id"
    t.integer "constellation_id"
    t.integer "region_id"
    t.integer "orbit_id"
    t.float   "x"
    t.float   "y"
    t.float   "z"
    t.float   "radius"
    t.string  "item_name"
    t.float   "security"
    t.integer "celestial_index"
    t.integer "orbit_index"
  end

  create_table "systems", force: :cascade do |t|
    t.integer  "item_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tower_stakes", force: :cascade do |t|
    t.integer  "pilot_id"
    t.integer  "tower_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tower_stakes", ["pilot_id"], name: "index_tower_stakes_on_pilot_id", using: :btree
  add_index "tower_stakes", ["tower_id"], name: "index_tower_stakes_on_tower_id", using: :btree

  create_table "towers", force: :cascade do |t|
    t.integer  "item_id",     limit: 8
    t.string   "name"
    t.integer  "type_id"
    t.integer  "state"
    t.integer  "fuel_blocks"
    t.integer  "strontium"
    t.integer  "moon_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "charters"
    t.boolean  "secure",                default: false
  end

  add_index "towers", ["moon_id"], name: "index_towers_on_moon_id", using: :btree

  add_foreign_key "moons", "systems"
  add_foreign_key "tower_stakes", "pilots"
  add_foreign_key "tower_stakes", "towers"
  add_foreign_key "towers", "moons"
end
