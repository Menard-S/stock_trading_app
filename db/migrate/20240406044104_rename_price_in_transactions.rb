class RenamePriceInTransactions < ActiveRecord::Migration[7.1]
  def change
    rename_column :transactions, :price, :transaction_price
  end
end