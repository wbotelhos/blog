# frozen_string_literal: true

class CreateLabs < ActiveRecord::Migration[6.0]
  def up
    create_table :labs do |t|
      t.string   :title, null: false
      t.string   :slug, null: false
      t.string   :version, null: false
      t.string   :description
      t.string   :keywords, null: false
      t.datetime :published_at
      t.text     :css
      t.text     :js
      t.text     :css_import
      t.text     :js_import
      t.text     :js_ready
      t.string   :analytics
      t.text     :body

      t.timestamps
    end

    add_index :labs, :title, unique: true
  end

  def down
    drop_table :labs
  end
end
