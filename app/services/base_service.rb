class BaseService
  def initialize(user)
    @user = user
  end

  protected

  def create_transaction(stock, quantity, type, price)
    Transaction.create!(
      user: @user,
      stock_id: stock.id,
      share: quantity,
      transaction_type: type,
      transaction_price: price,
      timestamp: Time.current
    )
  end
end
