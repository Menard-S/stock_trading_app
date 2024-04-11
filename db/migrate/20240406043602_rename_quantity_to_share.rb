class RenameQuantityToShare < ActiveRecord::Migration[7.1]
  def change
    rename_column :portfolios, :quantity, :share
    rename_column :transactions, :quantity, :share
  end
end