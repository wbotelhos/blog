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

ActiveRecord::Schema.define(:version => 20140101000003) do

  create_table "articles", :force => true do |t|
    t.datetime "published_at"
    t.string   "slug",         :null => false
    t.string   "title",        :null => false
    t.text     "body"
    t.integer  "user_id",      :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "articles", ["slug"], :name => "index_articles_on_slug", :unique => true
  add_index "articles", ["user_id"], :name => "index_articles_on_user_id"

  create_table "comments", :force => true do |t|
    t.boolean  "author",     :default => false, :null => false
    t.integer  "parent_id"
    t.string   "email",                         :null => false
    t.string   "name",                          :null => false
    t.string   "url"
    t.text     "body",                          :null => false
    t.integer  "article_id",                    :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "comments", ["article_id"], :name => "index_comments_on_article_id"

  create_table "labs", :force => true do |t|
    t.datetime "published_at"
    t.string   "description"
    t.string   "keywords",     :null => false
    t.string   "slug",         :null => false
    t.string   "title",        :null => false
    t.string   "version",      :null => false
    t.text     "body"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "labs", ["title"], :name => "index_labs_on_title", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",         :null => false
    t.string   "name",          :null => false
    t.string   "password_hash", :null => false
    t.string   "password_salt", :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
