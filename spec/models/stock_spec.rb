require 'rails_helper'

RSpec.describe Stock, type: :model do
  # Mock the IexService for testing
  let(:iex_service) { double('IexService') }

  before do
    allow(IexService).to receive(:fetch_quote).and_return({ latest_price: 150.0 }) # Mocking the IexService to return a quote with a specific price
  end

  # Test class methods
  describe '.update_all_current_prices' do
    let!(:stock1) { create(:stock, symbol: 'AAPL', current_price: 120.0) }
    let!(:stock2) { create(:stock, symbol: 'GOOGL', current_price: 130.0) }

    it 'updates current prices for all stocks' do
      expect { Stock.update_all_current_prices }.to change { stock1.reload.current_price }.from(120.0).to(150.0).and change { stock2.reload.current_price }.from(130.0).to(150.0)
      
      # Check logs for method calls
      # You may use a logger spy or mock if you want to test the logger statements as well
    end
  end

  # Test instance methods
  describe '#update_current_price' do
    let(:stock) { create(:stock, symbol: 'AAPL', current_price: 120.0) }

    it 'updates the current price of the stock' do
      expect { stock.update_current_price }.to change { stock.current_price }.from(120.0).to(150.0)
      
      # You can add assertions for logs if needed
      # Example:
      # expect(Rails.logger).to have_received(:info).with("Updating AAPL price to 150.0")
    end

    it 'logs an error if fetching the quote fails' do
      allow(IexService).to receive(:fetch_quote).and_return(nil) # Mocking failure to fetch quote
      
      expect(Rails.logger).to receive(:error).with("Failed to fetch quote for AAPL")
      stock.update_current_price
    end
  end
end
