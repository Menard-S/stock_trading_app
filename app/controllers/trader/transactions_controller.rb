class Trader::TransactionsController < ApplicationController
  def index
    @transactions = current_user.transactions.order(timestamp: :desc)
  end
end
