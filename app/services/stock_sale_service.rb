class StockSaleService < BaseService

  def sell(symbol, quantity)
    ActiveRecord::Base.transaction do
      stock = Stock.find_by(symbol: symbol)
      unless stock
        return { success: false, message: 'Stock not found' }
      end

      #Find portfolio for a stock 
      #Validates if the user has sufficent shares for the sell order
      portfolio = @user.portfolios.find_by(stock: stock)
      if portfolio.nil? || portfolio.share < quantity
        return { success: false, message: 'Not enough shares to sell' }
      end

      #Fetches the latest price from IEX, data refreshes after 15 mins as per documentation
      #Total revenue computes the total revenue for the sell order
      #Gain/loss is the difference between the IEX's latest price and the closing price
      price = IexService.fetch_quote(symbol)[:latest_price]
      total_revenue = price * quantity
      gain_loss = (price - portfolio.closing_price) * quantity
      
      # Adjust user's assets by adding the revenue from sale and subtracting the losses or adding gains
      @user.asset += total_revenue + gain_loss
      
      # Update portfolio or destroy if no shares remain
      portfolio.share -= quantity
      if portfolio.share <= 0
          portfolio.destroy!
      else
          portfolio.closing_price = price
          portfolio.save!
          portfolio.update_gains
      end
      
      # Save changes to the user
      @user.save!

      create_transaction(stock, quantity, 'sell', price)
      return { success: true, message: "Successfully sold #{quantity} #{'share'.pluralize(quantity)} of #{symbol}" }
    end
  rescue StandardError => e
    return { success: false, message: e.message }
  end
end