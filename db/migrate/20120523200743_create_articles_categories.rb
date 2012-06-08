class CreateArticlesCategories < ActiveRecord::Migration
  def up
    create_table :articles_categories do |t|
      t.references :article, :category
    end
  end

  def down
    drop_table :articles_categories
  end
end
