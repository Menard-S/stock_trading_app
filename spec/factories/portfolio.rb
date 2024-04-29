# spec/factories/portfolio.rb
FactoryBot.define do
    factory :portfolio do
      user
      stock
      share { 10 } # Set a default share quantity
      closing_price { 80.0 } # Set a default closing price
      gains { 200.0 } # Set a default gains amount
      # Add any other attributes as needed for your portfolio model
    end
  end
  