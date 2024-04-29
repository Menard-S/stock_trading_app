FactoryBot.define do
    factory :stock do
      symbol { 'GOOGL' }  # Example symbol
      company { 'Alphabet Inc -Class A' }  # Example company name
      current_price { 100.0 }  # Example current price
      # Add any other attributes as needed for your stock model
    end
  end