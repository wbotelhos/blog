class CreateArticles < ActiveRecord::Migration
  def up
    create_table :articles do |t|
      t.boolean     :delta,           null: false,  default: true
      t.string      :slug,            null: false
      t.string      :title,           null: false
      t.integer     :comments_count,  default: 0
      t.datetime    :published_at
      t.text        :body

      t.references  :user,            null: false

      t.timestamps
    end

    add_index :articles, :user_id
    add_index :articles, :slug, unique: true
  end

  def down
    drop_table :articles
  end
end
