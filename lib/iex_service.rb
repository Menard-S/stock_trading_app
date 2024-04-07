class IexService

  # Stocks We Support ticker in Home
  def self.fetch_iex_symbols
    client = IEX::Api::Client.new
    begin
      client.stock_market_list('mostactive').first(10).map do |stock|
        {
          symbol: stock.symbol,
          name: stock.company_name,
          latest_price: stock.latest_price
        }
      end
    rescue StandardError => e
      Rails.logger.error "Error fetching active stocks: #{e.message}"
      []
    end
  end  

  #Top 10 stocks in Home
  def self.fetch_top_symbols(list_type = 'mostactive')
    client = IEX::Api::Client.new
    client.stock_market_list(list_type).first(10).map do |quote|
      {
        symbol: quote.symbol,
        company_name: quote.company_name,
        primary_exchange: quote.primary_exchange,
        open: quote.open,
        close: quote.close,
        latest_volume: quote.latest_volume,
        market_cap: quote.market_cap
      }
    end
  rescue StandardError => e
    Rails.logger.error "Error fetching top symbols: #{e.message}"
    []
  end

  #Stock market list in Home
  def self.fetch_stock_market_list(list_type)
    client = IEX::Api::Client.new
    client.stock_market_list(list_type).map do |data|
      {
        symbol: data.symbol,
        company_name: data.company_name,
        primary_exchange: data.primary_exchange,
        latest_price: data.latest_price,
        change_percent: data.change_percent_s,
        market_cap: data.market_cap
      }
    end
  rescue StandardError => e
    []
  end

  #Stocks selector in trader portfolio
  def self.fetch_active_stocks
    client = IEX::Api::Client.new
    begin
      client.stock_market_list('mostactive').first(10).map do |stock|
        {
          symbol: stock.symbol,
          company_name: stock.company_name,
          latest_price: stock.latest_price
        }
      end
    rescue StandardError => e
      Rails.logger.error "Error fetching active stocks: #{e.message}"
      []
    end
  end

  #Stock details displayer in stock details partial
  def self.fetch_quote(symbol)
    client = IEX::Api::Client.new
    begin
      quote = client.quote(symbol)
      logo = client.logo(symbol)
      {
        symbol: quote.symbol,
        company_name: quote.company_name,
        latest_price: quote.latest_price,
        logo_url: logo.url
      }
    rescue StandardError => e
      Rails.logger.error "Error fetching quote for symbol #{symbol}: #{e.message}"
      nil
    end
  end
end