require 'rails_helper'

RSpec.describe Portfolio, type: :model do
  # Test validations
  describe 'validations' do
    it 'validates share is greater than or equal to 0' do
      portfolio = Portfolio.new(share: -1)
      expect(portfolio).not_to be_valid
      expect(portfolio.errors[:share]).to include('must be greater than or equal to 0')
    end
  end

  # Test instance methods
  describe '#update_gains' do
    let(:stock) { create(:stock, current_price: 150.0) }
    let(:portfolio) { create(:portfolio, stock: stock, share: 10, closing_price: 100.0) }

    it 'updates gains based on current price and closing price' do
      portfolio.update_gains
      expected_gains = (150.0 - 100.0) * 10
      expect(portfolio.gains).to eq(expected_gains)
    end
  end

  # Test class methods
  describe '.update_all_gains' do
    let!(:portfolio1) { create(:portfolio, closing_price: 100.0, share: 10) }
    let!(:portfolio2) { create(:portfolio, closing_price: 200.0, share: 20) }

    it 'updates gains for all portfolios' do
      expect { Portfolio.update_all_gains }.to change { portfolio1.reload.gains }.and change { portfolio2.reload.gains }

      # Check if the gains were updated correctly
      expected_gains1 = (portfolio1.stock.current_price - 100.0) * 10
      expected_gains2 = (portfolio2.stock.current_price - 200.0) * 20

      expect(portfolio1.gains).to eq(expected_gains1)
      expect(portfolio2.gains).to eq(expected_gains2)
    end
  end

  # Test the before_validation callback
  describe 'before_validation callback' do
    it 'sets default gains and share values' do
      portfolio = Portfolio.new
      portfolio.valid?
      expect(portfolio.gains).to eq(0.0)
      expect(portfolio.share).to eq(0)
    end
  end
end
