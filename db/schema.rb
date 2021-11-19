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

ActiveRecord::Schema.define(version: 2021_11_19_143745) do

  create_table "generations", force: :cascade do |t|
    t.string "world", null: false
    t.text "grid", null: false
    t.integer "iteration", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["iteration"], name: "index_generations_on_iteration"
    t.index ["world", "iteration"], name: "index_generations_on_world_and_iteration", unique: true
    t.index ["world"], name: "index_generations_on_world"
  end

end
