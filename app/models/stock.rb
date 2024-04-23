class Stock < ApplicationRecord
  has_many :portfolios
  has_many :transactions
  has_many :users, through: :portfolios

  def self.update_all_current_prices
    Rails.logger.info "Starting update of all stock prices"
    all.each do |stock|
      stock.update_current_price
      Rails.logger.info "Updated price for stock: #{stock.symbol}"
    end
    Rails.logger.info "Completed update of all stock prices"
  end

  def update_current_price
    quote = IexService.fetch_quote(symbol)
    if quote
      self.current_price = quote[:latest_price]
      Rails.logger.info "Updating #{symbol} price to #{self.current_price}"
      save_result = save
      Rails.logger.info "Save #{symbol}: #{save_result}"
    else
      Rails.logger.error "Failed to fetch quote for #{symbol}"
    end
  end
end