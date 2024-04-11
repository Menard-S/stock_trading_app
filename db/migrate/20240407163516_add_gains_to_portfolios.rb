class AddGainsToPortfolios < ActiveRecord::Migration[7.1]
  def change
    add_column :portfolios, :gains, :decimal, precision: 10, scale: 2
  end
end
