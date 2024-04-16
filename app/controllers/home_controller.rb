class HomeController < ApplicationController
  before_action :set_iex_symbols, only: [:index]
  before_action :set_top_symbols
  before_action :set_stock_market_list
  before_action :calculate_total_gains, if: :user_signed_in?
  before_action :calculate_asset_balance, if: :user_signed_in?

  private

  def set_iex_symbols
    @iex_symbols = IexService.fetch_iex_symbols
  end

  def set_top_symbols
    @top_symbols = IexService.fetch_top_symbols('mostactive')
  end

  def set_stock_market_list
    list_type = 'mostactive'
    @stock_market_list = IexService.fetch_stock_market_list(list_type)
  end

  def calculate_total_gains
    @total_gains = current_user.portfolios.sum(:gains)
  end

  def calculate_asset_balance
    @asset_balance = current_user.asset
  end
end