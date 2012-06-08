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

ActiveRecord::Schema.define(:version => 20120523200743) do

  create_table "articles", :force => true do |t|
    t.string   "title",                            :null => false
    t.text     "body",                             :null => false
    t.datetime "published_at"
    t.integer  "user_id",                          :null => false
    t.integer  "comments_count", :default => 0
    t.boolean  "delta",          :default => true, :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "articles", ["user_id"], :name => "index_articles_on_user_id"

  create_table "articles_categories", :force => true do |t|
    t.integer "article_id"
    t.integer "category_id"
  end

  create_table "categories", :force => true do |t|
    t.string   "name",                          :null => false
    t.integer  "articles_count", :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "comments", :force => true do |t|
    t.string   "name",                          :null => false
    t.string   "email",                         :null => false
    t.string   "url"
    t.text     "body",                          :null => false
    t.boolean  "author",     :default => false, :null => false
    t.integer  "article_id",                    :null => false
    t.integer  "comment_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "comments", ["article_id"], :name => "index_comments_on_article_id"

  create_table "links", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "url",        :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",                          :null => false
    t.string   "email",                         :null => false
    t.text     "bio"
    t.string   "url"
    t.string   "github"
    t.string   "linkedin"
    t.string   "twitter"
    t.string   "facebook"
    t.string   "password_hash",                 :null => false
    t.string   "password_salt",                 :null => false
    t.integer  "articles_count", :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
