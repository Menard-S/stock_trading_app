class AddDetailsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :yob, :integer, null: false
    add_column :users, :asset, :decimal, precision: 10, scale: 2, null: false
  end
end
