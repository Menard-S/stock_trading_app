class AddStockForeignKeyToTransactions < ActiveRecord::Migration[7.1]
  def change
    add_column :transactions, :stock_id, :bigint
    remove_column :transactions, :stock, :string
    add_foreign_key :transactions, :stocks, column: :stock_id
  end
end
