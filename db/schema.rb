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

ActiveRecord::Schema.define(version: 20170309041737) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "icon_source"
  end

  create_table "completed_questions", force: :cascade do |t|
    t.integer  "user_category_id"
    t.integer  "question_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["question_id"], name: "index_completed_questions_on_question_id", using: :btree
    t.index ["user_category_id"], name: "index_completed_questions_on_user_category_id", using: :btree
  end

  create_table "questions", force: :cascade do |t|
    t.string   "category_name"
    t.string   "question_type"
    t.string   "difficulty"
    t.text     "question"
    t.string   "correct_answer"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "incorrect_answers", default: [],              array: true
    t.integer  "exp"
    t.integer  "category_id"
    t.index ["category_id"], name: "index_questions_on_category_id", using: :btree
  end

  create_table "user_categories", force: :cascade do |t|
    t.integer  "category_exp", default: 0
    t.integer  "user_id"
    t.integer  "category_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "highscore",    default: 0
    t.index ["category_id"], name: "index_user_categories_on_category_id", using: :btree
    t.index ["user_id"], name: "index_user_categories_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "profile_picture"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "title"
    t.string   "location"
  end

  add_foreign_key "completed_questions", "questions"
  add_foreign_key "completed_questions", "user_categories"
  add_foreign_key "questions", "categories"
  add_foreign_key "user_categories", "categories"
  add_foreign_key "user_categories", "users"
end
