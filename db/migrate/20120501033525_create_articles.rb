class CreateArticles < ActiveRecord::Migration
  def up
    create_table :articles do |t|
      t.string :title, null: false
      t.text :body
      t.string :slug, null: false
      t.datetime :published_at

      t.references :user, null: false
      t.integer :comments_count, default: 0
      t.boolean :delta, default: true, null: false

      t.timestamps
    end

    add_index :articles, :user_id
    add_index :articles, :slug, unique: true
  end

  def down
    drop_table :articles
  end
end
