class HomeController < ApplicationController
  before_action :set_iex_symbols, only: [:index]
  before_action :set_top_symbols
  before_action :set_stock_market_list

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
end