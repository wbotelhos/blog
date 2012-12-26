class CreateLabs < ActiveRecord::Migration
  def up
    create_table :labs do |t|
      t.string   :name,         null: false
      t.string   :slug,         null: false
      t.datetime :published_at
      t.string   :description
      t.string   :image

      t.timestamps
    end

    add_index :labs, :name, unique: true
  end

  def down
    drop_table :labs
  end
end
