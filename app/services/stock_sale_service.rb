class StockSaleService < BaseService

  def sell(symbol, quantity)
    ActiveRecord::Base.transaction do
      stock = Stock.find_by(symbol: symbol)
      unless stock
        return { success: false, message: 'Stock not found' }
      end

      portfolio = @user.portfolios.find_by(stock: stock)
      if portfolio.nil? || portfolio.share < quantity
        return { success: false, message: 'Not enough shares to sell' }
      end

      portfolio.share -= quantity
      if portfolio.share <= 0
        portfolio.destroy!
      else
        portfolio.save!
      end

      price = IexService.fetch_quote(symbol)[:latest_price]
      Rails.logger.debug "Price for #{symbol}: #{price}"

      portfolio.closing_price = price
      portfolio.save!

      total_cost = price * quantity

      @user.asset += total_cost
      @user.save!

      create_transaction(stock, quantity, 'sell', price)
      return { success: true, message: "Successfully sold #{quantity} #{'share'.pluralize(quantity)} of #{symbol}" }
    end
  rescue StandardError => e
    return { success: false, message: e.message }
  end
end