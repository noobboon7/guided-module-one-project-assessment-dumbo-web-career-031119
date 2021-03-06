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

ActiveRecord::Schema.define(version: 2019_04_17_152919) do

  create_table "parties", force: :cascade do |t|
    t.integer "pokeball_id"
    t.integer "trainer_id"
  end

  create_table "pcs", force: :cascade do |t|
    t.integer "trainer_id"
    t.integer "pokeball_id"
  end

  create_table "pokeballs", force: :cascade do |t|
    t.integer "trainer_id"
    t.integer "pokemon_id"
  end

  create_table "pokemons", force: :cascade do |t|
    t.string "name"
    t.string "element"
    t.integer "total"
    t.integer "hp"
    t.integer "attack"
    t.integer "defense"
    t.integer "speed"
  end

  create_table "trainers", force: :cascade do |t|
    t.string "name"
    t.string "sex"
    t.string "password"
  end

end
