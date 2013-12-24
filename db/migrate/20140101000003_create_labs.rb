class CreateLabs < ActiveRecord::Migration
  def up
    create_table :labs do |t|
      t.datetime :published_at
      t.string   :description
      t.string   :slug         , null: false
      t.string   :title        , null: false
      t.text     :body

      t.timestamps
    end

    add_index :labs, :title, unique: true
  end

  def down
    drop_table :labs
  end
end
