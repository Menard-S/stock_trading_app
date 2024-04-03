class CreateStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.string :company

      t.timestamps
    end
    add_index :stocks, :symbol, unique: true
  end
end
