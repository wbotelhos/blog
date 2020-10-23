# frozen_string_literal: true

class CreateArticles < ActiveRecord::Migration[6.0]
  def up
    create_table :articles do |t|
      t.string   :title, null: false
      t.string   :slug, null: false
      t.datetime :published_at
      t.text     :body

      t.references :user, foreign_key: true, index: true, null: false

      t.timestamps
    end

    add_index :articles, :slug, unique: true
  end

  def down
    drop_table :articles
  end
end
