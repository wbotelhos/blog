class ChangeAssetColumnsToTextAtLabs < ActiveRecord::Migration
  def change
    change_column :labs, :css_import, :text
    change_column :labs, :js        , :text
    change_column :labs, :js_import , :text
  end
end
