class AddDefaultAssetToUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :asset, 0
  end
end
