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

ActiveRecord::Schema.define(version: 20140101000003) do

  create_table "articles", force: :cascade do |t|
    t.datetime "published_at"
    t.string   "slug",         limit: 255,   null: false
    t.string   "title",        limit: 255,   null: false
    t.text     "body",         limit: 65535
    t.integer  "user_id",      limit: 4,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "articles", ["slug"], name: "index_articles_on_slug", unique: true, using: :btree
  add_index "articles", ["user_id"], name: "index_articles_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.boolean  "author",           limit: 1,     default: false, null: false
    t.boolean  "pending",          limit: 1,     default: true,  null: false
    t.integer  "parent_id",        limit: 4
    t.string   "email",            limit: 255,                   null: false
    t.string   "name",             limit: 255,                   null: false
    t.string   "url",              limit: 255
    t.text     "body",             limit: 65535,                 null: false
    t.integer  "commentable_id",   limit: 4,                     null: false
    t.string   "commentable_type", limit: 255,                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type", using: :btree

  create_table "labs", force: :cascade do |t|
    t.datetime "published_at"
    t.string   "analytics",    limit: 255
    t.string   "css_import",   limit: 255
    t.string   "description",  limit: 255
    t.string   "js",           limit: 255
    t.string   "js_import",    limit: 255
    t.string   "keywords",     limit: 255,   null: false
    t.string   "slug",         limit: 255,   null: false
    t.string   "title",        limit: 255,   null: false
    t.string   "version",      limit: 255,   null: false
    t.text     "body",         limit: 65535
    t.text     "js_ready",     limit: 65535
    t.text     "css",          limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "labs", ["title"], name: "index_labs_on_title", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",         limit: 255, null: false
    t.string   "password_hash", limit: 255, null: false
    t.string   "password_salt", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
