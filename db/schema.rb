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

ActiveRecord::Schema.define(version: 20131105031942) do

  create_table "discussions", force: true do |t|
    t.integer  "discussable_id"
    t.integer  "type"
    t.text     "content"
    t.integer  "user_from"
    t.string   "user_to"
    t.string   "user_cc"
    t.string   "user_bcc"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "discussable_type"
  end

  add_index "discussions", ["discussable_id", "discussable_type"], name: "index_discussions_on_discussable_id_and_discussable_type", using: :btree

  create_table "early_adopters", force: true do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "early_adopters", ["email"], name: "index_early_adopters_on_email", unique: true, using: :btree

  create_table "organization_memberships", force: true do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.integer  "authority_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "organization_memberships", ["organization_id"], name: "index_organization_memberships_on_organization_id", using: :btree
  add_index "organization_memberships", ["user_id"], name: "index_organization_memberships_on_user_id", using: :btree

  create_table "organizations", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "plan"
  end

  create_table "taggings", force: true do |t|
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.integer  "tag_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type"], name: "index_taggings_on_taggable_id_and_taggable_type", using: :btree

  create_table "tags", force: true do |t|
    t.string   "name"
    t.string   "color"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "tags", ["organization_id"], name: "index_tags_on_organization_id", using: :btree

  create_table "topics", force: true do |t|
    t.string   "title"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "topics", ["organization_id"], name: "index_topics_on_organization_id", using: :btree

  create_table "upload_files", force: true do |t|
    t.string   "name"
    t.string   "file"
    t.integer  "discussion_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "content_type"
  end

  create_table "user_discussions", force: true do |t|
    t.integer  "user_id"
    t.integer  "discussion_id"
    t.integer  "read_status"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "user_discussions", ["discussion_id"], name: "index_user_discussions_on_discussion_id", using: :btree
  add_index "user_discussions", ["user_id"], name: "index_user_discussions_on_user_id", using: :btree

  create_table "user_topics", force: true do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.integer  "archive_status"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "user_topics", ["topic_id"], name: "index_user_topics_on_topic_id", using: :btree
  add_index "user_topics", ["user_id"], name: "index_user_topics_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email",                   null: false
    t.string   "password_digest"
    t.string   "remember_token"
    t.integer  "online_status"
    t.integer  "active_status"
    t.integer  "authority_type"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "active_code"
    t.string   "reset_token"
    t.integer  "default_organization_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
