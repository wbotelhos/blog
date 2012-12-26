class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string  :email,         null: false
      t.string  :name,          null: false
      t.string  :password_hash, null: false
      t.string  :password_salt, null: false
      t.string  :facebook
      t.string  :github
      t.string  :linkedin
      t.string  :twitter
      t.string  :url
      t.text    :bio

      t.integer :articles_count, default: 0

      t.timestamps
    end

    add_index :users, :email, unique: true
  end

  def down
    drop_table :users
  end
end
