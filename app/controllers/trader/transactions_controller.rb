class Trader::TransactionsController < ApplicationController
  def index
    @transactions = current_user.transactions.order(timestamp: :desc)
    user_transaction_balance = current_user.asset
    @transaction_balances = {}
    @transactions.each do |transaction|
      amount_changed = transaction.transaction_price
      running_balance = user_transaction_balance
      user_transaction_balance += amount_changed * (transaction.transaction_type == 'sell' ? -1 : 1)
      @transaction_balances[transaction.id] = { before: user_transaction_balance, after: running_balance }
    end
  end
end