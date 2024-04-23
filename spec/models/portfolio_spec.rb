require 'rails_helper'

RSpec.describe Portfolio, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  # Test validations
  #  validation of the share attribute to ensure it's greater than or equal to 0.
   describe 'validations' do
    it 'validates share is greater than or equal to 0' do
      portfolio = Portfolio.new(share: -1)
      expect(portfolio).not_to be_valid
      expect(portfolio.errors[:share]).to include("must be greater than or equal to 0")
    end
  end

  # Test methods
  # ensures that the gains are calculated correctly based on the current and closing prices and the number of shares.
  describe '#update_gains' do
    let(:stock) { create(:stock, current_price: 150.0) }
    let(:portfolio) { create(:portfolio, stock: stock, share: 10, closing_price: 100.0) }

    it 'updates gains based on current price and closing price' do
      portfolio.update_gains
      expect(portfolio.gains).to eq(500.0) # (150 - 100) * 10
    end
  end
  # tests the behavior of the update_all_gains method. It ensures that the method updates gains for all portfolios.
  describe '.update_all_gains' do
    let!(:portfolio1) { create(:portfolio, closing_price: 100.0, share: 10) }
    let!(:portfolio2) { create(:portfolio, closing_price: 200.0, share: 20) }

    it 'updates gains for all portfolios' do
      allow(Portfolio).to receive(:all).and_return([portfolio1, portfolio2])
      
      expect(portfolio1).to receive(:update_gains)
      expect(portfolio2).to receive(:update_gains)

      Portfolio.update_all_gains
    end
  end
  # tests the before_validation callback method set_default_values to ensure it sets default gains and share values to 0.
  describe 'before_validation callback' do
    it 'sets default gains and share values' do
      portfolio = Portfolio.new
      portfolio.valid?
      expect(portfolio.gains).to eq(0.0)
      expect(portfolio.share).to eq(0)
    end
  end
end
