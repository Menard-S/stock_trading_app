require "test_helper"

class Trader::PortfolioControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get trader_portfolio_show_url
    assert_response :success
  end

  test "should get buy" do
    get trader_portfolio_buy_url
    assert_response :success
  end

  test "should get sell" do
    get trader_portfolio_sell_url
    assert_response :success
  end
end
