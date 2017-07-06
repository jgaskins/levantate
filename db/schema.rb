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

ActiveRecord::Schema.define(version: 20170630205428) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "engineers", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "login",      null: false
    t.string   "avatar_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["login"], name: "index_engineers_on_login", using: :btree
  end

  create_table "pull_requests", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "title"
    t.string   "number"
    t.string   "url"
    t.string   "repo"
    t.integer  "state",                 default: 0
    t.datetime "awaiting_review_since"
    t.uuid     "author_id"
    t.uuid     "reviewer_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "github_id"
    t.index ["author_id"], name: "index_pull_requests_on_author_id", using: :btree
    t.index ["reviewer_id"], name: "index_pull_requests_on_reviewer_id", using: :btree
  end

  create_table "reviews", force: :cascade do |t|
    t.integer  "state",           default: 0
    t.string   "github_id"
    t.string   "url"
    t.text     "body"
    t.uuid     "author_id"
    t.uuid     "pull_request_id"
    t.datetime "submitted_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.index ["author_id"], name: "index_reviews_on_author_id", using: :btree
    t.index ["pull_request_id"], name: "index_reviews_on_pull_request_id", using: :btree
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.uuid     "engineer_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["engineer_id"], name: "index_users_on_engineer_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "pull_requests", "engineers", column: "author_id"
  add_foreign_key "pull_requests", "engineers", column: "reviewer_id"
  add_foreign_key "reviews", "engineers", column: "author_id"
  add_foreign_key "reviews", "pull_requests"
  add_foreign_key "users", "engineers"
end
