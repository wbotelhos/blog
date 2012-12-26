class CreateDonators < ActiveRecord::Migration
  def up
    create_table :donators do |t|
      t.string  :email,   null: false
      t.string  :name,    null: false
      t.float   :amount
      t.string  :about
      t.string  :country
      t.string  :message
      t.string  :url

      t.timestamps
    end
  end

  def down
    drop_table :donators
  end
end
