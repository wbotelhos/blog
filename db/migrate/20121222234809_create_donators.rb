class CreateDonators < ActiveRecord::Migration
  def up
    create_table :donators do |t|
      t.string  :name, null: false
      t.string  :email, null: false
      t.string  :url
      t.float   :amount
      t.string  :about
      t.string  :country
      t.string  :message

      t.timestamps
    end
  end

  def down
    drop_table :donators
  end
end
