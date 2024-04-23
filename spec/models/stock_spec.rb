require 'rails_helper'

RSpec.describe Stock, type: :model do
  # describe 'validations' do
  #   it { should validate_presence_of(:symbol) }
  #   it { should validate_presence_of(:company) }
  #   it { should validate_presence_of(:current_price) }
  # end

 # Test validations
  describe 'validations' do
    it 'validates presence of symbol' do
      stock = Stock.new(company: 'Test Company', current_price: 100.0)
      expect(stock).not_to be_valid
      expect(stock.errors[:symbol]).to include("can't be blank")
    end

    it 'validates presence of company' do
      stock = Stock.new(symbol: 'TEST', current_price: 100.0)
      expect(stock).not_to be_valid
      expect(stock.errors[:company]).to include("can't be blank")
    end

    it 'validates presence of current_price' do
      stock = Stock.new(symbol: 'TEST', company: 'Test Company')
      expect(stock).not_to be_valid
      expect(stock.errors[:current_price]).to include("can't be blank")
    end
  end

end
