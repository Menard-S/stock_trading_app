class MoveClosingPriceFromStocksToPortfolios < ActiveRecord::Migration[7.1]
  def change
    add_column :portfolios, :closing_price, :decimal, precision: 10, scale: 2
    remove_column :stocks, :closing_price, :decimal, precision: 10, scale: 2
  end
end