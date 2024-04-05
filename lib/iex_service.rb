class IexService

  def self.fetch_iex_symbols
    client = IEX::Api::Client.new
    begin
      symbols = client.ref_data_symbols
      if symbols.empty?
        Rails.logger.error 'IEX symbols list is empty.'
        return []
      end
      symbols.map do |symbol|
        {
          symbol: symbol.symbol,
          name: symbol.name
        }
      end
    rescue StandardError => e
      Rails.logger.error "Error fetching IEX symbols: #{e.message}"
      []
    end
  end

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
end
