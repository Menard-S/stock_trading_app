class StockPurchaseService < BaseService

  def buy(symbol, quantity)
    ActiveRecord::Base.transaction do
      stock = Stock.find_or_create_by(symbol: symbol)
      
      #Find / create portfolio for a stock 
      portfolio = @user.portfolios.find_or_initialize_by(stock: stock)
      price = IexService.fetch_quote(symbol)[:latest_price]
      Rails.logger.debug "Price for #{symbol}: #{price}"
     
      #Validates if the user has sufficent asset for the buy order
      #Updates the user's asset
      total_cost = price * quantity
      
      if total_cost > @user.asset
        return { success: false, message: 'Insufficient funds to complete this transaction' }
      end

      # Deducts the total cost from user's asset
      @user.asset -= total_cost
      
      #Updates share attribute for portfolios table with the number of shares
      #Updates closing price attribute for portfolios table with the price fetched from IEX
      #Calls update_gains from Portfolio model
      #Saves the portfolio
      portfolio.share = (portfolio.share || 0) + quantity
      portfolio.closing_price = price
      portfolio.update_gains
      portfolio.save!

      #Saves the user
      @user.save!

      #Calls create transaction from base_service to create the transaction
      create_transaction(stock, quantity, 'buy', price)

      return { success: true, message: "Successfully purchased #{quantity} #{'share'.pluralize(quantity)} of #{symbol}" }
    end
  rescue StandardError => e
    return { success: false, message: e.message }
  end
end