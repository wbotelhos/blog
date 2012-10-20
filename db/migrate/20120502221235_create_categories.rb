class CreateCategories < ActiveRecord::Migration
  def up
    create_table :categories do |t|
      t.string :name, null: false

      t.integer :articles_count, default: 0

      t.timestamps
    end
  end

  def down
    drop_table :categories
  end
end
