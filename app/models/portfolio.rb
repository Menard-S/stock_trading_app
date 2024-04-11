class Portfolio < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  validates :share, numericality: { greater_than_or_equal_to: 0 }

  def update_gains
    current_price = stock.current_price.to_f
    closing_price = self.closing_price.to_f
    share_count = share.to_f

    Rails.logger.info "Updating gains: Stock=#{stock.symbol}, Current Price=#{current_price}, Closing Price=#{closing_price}, Shares=#{share_count}"

    self.gains = (current_price - closing_price) * share_count

    save
  end

  def self.update_all_gains
    Rails.logger.info "Starting update of all portfolio gains"
    all.find_each do |portfolio|
      begin
        portfolio.update_gains
        Rails.logger.info "Updated gains for portfolio: #{portfolio.id}"
      rescue StandardError => e
        Rails.logger.error "Error updating gains for portfolio #{portfolio.id}: #{e.message}"
      end
    end
    Rails.logger.info "Completed update of all portfolio gains"
  end
end
