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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130917120146) do

  create_table "discussions", :force => true do |t|
    t.integer  "discussable_id"
    t.integer  "type"
    t.text     "content"
    t.integer  "user_from"
    t.integer  "user_to"
    t.integer  "user_cc"
    t.integer  "user_bcc"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "discussable_type"
  end

  create_table "early_adopters", :force => true do |t|
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "organization_memberships", :force => true do |t|
    t.integer  "organization_id"
    t.integer  "user_id"
    t.integer  "authority_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "organizations", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "plan"
  end

  create_table "topics", :force => true do |t|
    t.string   "title"
    t.integer  "organization_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "user_discussions", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "discussion_id"
    t.integer  "read_status"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "user_topics", :force => true do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.integer  "archive_status"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email",                   :null => false
    t.string   "password"
    t.string   "remember_token"
    t.integer  "online_status"
    t.integer  "active_status"
    t.integer  "authority_type"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.string   "active_code"
    t.string   "reset_token"
    t.integer  "default_organization_id"
  end

end
