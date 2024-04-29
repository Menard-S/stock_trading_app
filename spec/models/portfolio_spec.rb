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
