# spec/system/trader_start_trading_spec.rb
require 'rails_helper'

RSpec.describe 'Trader Start Trading', type: :system do

  let!(:trader_user) { create(:user, role: :trader, status: :approved, password: 'password123', email: 'trader@example.com', asset: 20000) }
  let!(:stock) { create(:stock, symbol: 'GOOGL', company: 'Alphabet Inc - Class A', current_price: 171.95) }
  let!(:portfolio) { create(:portfolio, user: trader_user, stock: stock, share: 10, closing_price: 80.0, gains: 200.0) }

  before do
    driven_by(:rack_test)  # Use Capybara's rack test driver
    login_as(trader_user, scope: :user)  # Log in as the trader
  end

  it 'allows a trader to start trading' do
    # Visit the home page
    visit root_path

    # Check if there is an option to start trading
    expect(page).to have_link('I want to start trading', href: trader_portfolio_path)

    # Click the link to start trading
    click_link 'I want to start trading'

    # Assert that trader is redirected to the portfolio page
    expect(page).to have_current_path(trader_portfolio_path)
    expect(page).to have_content("Hello #{trader_user.name}!")

    # Perform further actions on the portfolio page, such as buying or selling stocks
    # Add your testing logic here for executing trades, asserting outcomes, etc.

    # Locate the dropdown list using its ID or name
    dropdown = find('#symbol')

    # Click the dropdown list to expand it
    dropdown.click

    # Use `click_on` to select the option 'GOOGL' by its visible text
    click_on('GOOGL')

    # Verify the HTTP response status is a 200 OK after form submission
    expect(page.status_code).to eq(200)

    # Wait for the form submission and the page to reload
    # Assert the current path matches the expected path
    expect(page).to have_current_path(trader_fetch_stock_path(symbol: 'GOOGL'))

    # Check for the stock details on the page
    expect(page).to have_content('Place your buy or sell order by entering the number of stocks below')
    expect(page).to have_content('GOOGL - Alphabet Inc - Class A')
  end

  it 'allows a trader to buy if sufficient balance stocks' do
    # Visit the trader portfolio fetch_stock page
    visit trader_fetch_stock_path(symbol: 'GOOGL')

    # Verify stock details on the page
    expect(page).to have_content('Place your buy or sell order by entering the number of stocks below')

    # Attempt to buy 20 shares
    fill_in 'quantity', with: 20

    # click_button 'Buy'
    click_button 'Buy'

    # Assert expected outcomes based on trader's balance and buying action
    if trader_user.asset >= stock.current_price * 20
      expect(page).to have_content('Successfully purchased 20 shares of GOOGL')
    else
        expect(page).to have_content('Insufficient balance')
    end
  end

  it 'allows a trader to sell if there is available shares' do
    # Visit the trader portfolio fetch_stock page
    visit trader_fetch_stock_path(symbol: 'GOOGL')
    
    # Verify stock details on the page
    expect(page).to have_content('Place your buy or sell order by entering the number of stocks below')

    # Simulate attempting to sell stock
     fill_in 'quantity', with: 5 # Selling 5 shares of GOOGL
     click_button 'Sell'
 
    # Assert expected outcomes based on the trader's shares and selling action
    if portfolio.share >= 5
      expect(page).to have_content('Successfully sold 5 shares of GOOGL')
    else
      expect(page).to have_content('Not enough shares to sell')
    end
  end
  
end
