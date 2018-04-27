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

ActiveRecord::Schema.define(version: 2018_04_20_222526) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "project_evaluations", force: :cascade do |t|
    t.text "evaluation"
  end

  create_table "project_students", force: :cascade do |t|
    t.integer "project_id"
    t.string "token"
    t.string "name"
    t.string "email"
    t.integer "grades", array: true
    t.text "evaluation"
    t.datetime "evaluated_at"
    t.boolean "sent", default: false
    t.datetime "sent_at"
    t.index ["token"], name: "index_project_students_on_token"
  end

  create_table "projects", force: :cascade do |t|
    t.string "course"
    t.string "name"
    t.text "students"
    t.string "components", array: true
  end

end
