class CreateLabs < ActiveRecord::Migration
  def up
    create_table :labs do |t|
      t.datetime :published_at
      t.string   :analytics
      t.string   :css_import
      t.string   :description
      t.string   :js
      t.string   :js_import
      t.string   :keywords, null: false
      t.string   :slug, null: false
      t.string   :title, null: false
      t.string   :version, null: false
      t.text     :body
      t.text     :js_ready
      t.text :css

      t.timestamps
    end

    add_index :labs, :title, unique: true
  end

  def down
    drop_table :labs
  end
end
