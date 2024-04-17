class AddDefaultNameToUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :name, "Unknown"
  end
end
