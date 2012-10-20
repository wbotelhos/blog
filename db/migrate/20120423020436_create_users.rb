class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string  :name, null: false
      t.string  :email, null: false
      t.text    :bio
      t.string  :url
      t.string  :github
      t.string  :linkedin
      t.string  :twitter
      t.string  :facebook
      t.string  :password_hash, null: false
      t.string  :password_salt, null: false

      t.integer :articles_count, default: 0

      t.timestamps
    end

    add_index :users, :email, unique: true
  end

  def down
    drop_table :users
  end
end
