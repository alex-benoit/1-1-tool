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

ActiveRecord::Schema[7.0].define(version: 2023_06_04_204757) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "checkins", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "morale"
    t.string "morale_comment"
    t.text "wins"
    t.text "blockers"
    t.integer "workload"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "summary"
    t.string "past_week_prompt"
    t.string "coming_week_prompt"
    t.index ["user_id"], name: "index_checkins_on_user_id"
  end

  create_table "priorities", force: :cascade do |t|
    t.string "title"
    t.datetime "completed_at"
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "checkin_id"
    t.index ["checkin_id"], name: "index_priorities_on_checkin_id"
  end

  create_table "relationships", force: :cascade do |t|
    t.bigint "manager_id", null: false
    t.bigint "direct_report_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["direct_report_id"], name: "index_relationships_on_direct_report_id"
    t.index ["manager_id", "direct_report_id"], name: "index_relationships_on_manager_id_and_direct_report_id", unique: true
    t.index ["manager_id"], name: "index_relationships_on_manager_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "title"
    t.bigint "relationship_id", null: false
    t.datetime "completed_at"
    t.datetime "archived_at"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "ai_suggested", default: false
    t.index ["author_id"], name: "index_topics_on_author_id"
    t.index ["relationship_id"], name: "index_topics_on_relationship_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "description"
    t.jsonb "feedback_conversation"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "checkins", "users"
  add_foreign_key "priorities", "checkins"
  add_foreign_key "relationships", "users", column: "direct_report_id"
  add_foreign_key "relationships", "users", column: "manager_id"
  add_foreign_key "topics", "relationships"
  add_foreign_key "topics", "users", column: "author_id"
end
