class CreateLinks < ActiveRecord::Migration
  def up
    create_table :links do |t|
      t.string :name, null: false
      t.string :url,  null: false

      t.timestamps
    end

    add_index :links, :name,  unique: true
    add_index :links, :url,   unique: true
  end

  def down
    drop_table :links
  end
end
