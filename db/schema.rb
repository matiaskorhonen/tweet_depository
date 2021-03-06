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

ActiveRecord::Schema.define(:version => 20120817145542) do

  create_table "statuses", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sid",                     :limit => 8
    t.text     "text"
    t.string   "source"
    t.string   "in_reply_to_user_id"
    t.string   "in_reply_to_screen_name"
    t.datetime "tweeted_at"
    t.text     "raw_hash"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "is_retweet"
  end

  add_index "statuses", ["in_reply_to_screen_name"], :name => "index_statuses_on_in_reply_to_screen_name"
  add_index "statuses", ["in_reply_to_user_id"], :name => "index_statuses_on_in_reply_to_user_id"
  add_index "statuses", ["sid"], :name => "index_statuses_on_sid", :unique => true
  add_index "statuses", ["user_id"], :name => "index_statuses_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.integer  "uid",           :limit => 8
    t.string   "name"
    t.text     "raw_auth_hash"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.text     "credentials"
  end

  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["provider"], :name => "index_users_on_provider"
  add_index "users", ["uid"], :name => "index_users_on_uid", :unique => true

end
