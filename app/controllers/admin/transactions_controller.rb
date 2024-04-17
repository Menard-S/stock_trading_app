# app/controllers/admin/transactions_controller.rb
class Admin::TransactionsController < Admin::BaseController
    def index
      @transactions = Transaction.all
      @stocks = Stock.all
    end
  end
  