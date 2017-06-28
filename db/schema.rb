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

ActiveRecord::Schema.define(version: 20170623123155) do

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
    t.integer  "number"
    t.string   "url"
    t.string   "repo"
    t.integer  "state",                 default: 0
    t.datetime "awaiting_review_since"
    t.uuid     "author_id"
    t.uuid     "reviewer_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["author_id"], name: "index_pull_requests_on_author_id", using: :btree
    t.index ["reviewer_id"], name: "index_pull_requests_on_reviewer_id", using: :btree
  end

  add_foreign_key "pull_requests", "engineers", column: "author_id"
  add_foreign_key "pull_requests", "engineers", column: "reviewer_id"
end
