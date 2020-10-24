# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[6.0]
  def up
    create_table :comments do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :url
      t.boolean :author, null: false, default: false
      t.boolean :pending, null: false, default: true
      t.integer :parent_id
      t.text :body, null: false

      t.references :commentable, null: false, polymorphic: true

      t.timestamps
    end

    add_index :comments, %i[commentable_id commentable_type]
  end

  def down
    drop_table :comments
  end
end
