class StockPurchaseService < BaseService

  def buy(symbol, quantity)
    ActiveRecord::Base.transaction do
      stock = Stock.find_or_create_by(symbol: symbol)
      
      price = IexService.fetch_quote(symbol)[:latest_price]
      Rails.logger.debug "Price for #{symbol}: #{price}"

      stock.closing_price = price
      stock.save!
      
      total_cost = price * quantity
      
      if total_cost > @user.asset
        return { success: false, message: 'Insufficient funds to complete this transaction' }
      end

      portfolio = @user.portfolios.find_or_initialize_by(stock: stock)
      portfolio.share = (portfolio.share || 0) + quantity
      portfolio.save!

      @user.asset -= total_cost
      @user.save!

      create_transaction(stock, quantity, 'buy', price)

      return { success: true, message: "Successfully purchased #{quantity} shares of #{symbol}" }
    end
  rescue StandardError => e
    return { success: false, message: e.message }
  end
end