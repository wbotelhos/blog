class CreateCategories < ActiveRecord::Migration
  def up
    create_table :categories do |t|
      t.integer :articles_count,  default: 0
      t.string  :name,            null: false

      t.timestamps
    end

    add_index :categories, :name, unique: true
  end

  def down
    drop_table :categories
  end
end
