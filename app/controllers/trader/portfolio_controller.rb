class Trader::PortfolioController < Trader::BaseController
  def show
    @active_stocks = IexService.fetch_iex_symbols
    @user_portfolio = @user.portfolios.includes(:stock)
  end

  def fetch_stock
    symbol = params[:symbol]
    @stock = IexService.fetch_quote(symbol)
    render partial: 'stock_details', locals: { stock: @stock }
  end

  def process_order
    symbol = params[:symbol]
    quantity = params[:quantity].to_i
    action = params[:commit]

    if action == 'Buy'
      result = StockPurchaseService.new(@user).buy(symbol, quantity)
    elsif action == 'Sell'
      result = StockSaleService.new(@user).sell(symbol, quantity)
    end

    if result[:success]
      redirect_to trader_portfolio_path, notice: result[:message]
    else
      redirect_to trader_portfolio_path, alert: result[:message]
    end
  end
end
