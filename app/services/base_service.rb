class BaseService
  def initialize(user)
    @user = user
  end

  protected

  def create_transaction(stock, quantity, type, price)
    total_price = price * quantity
    Transaction.create!(
      user: @user,
      stock_id: stock.id,
      share: quantity,
      transaction_type: type,
      transaction_price: total_price,
      timestamp: Time.current
    )
  end
end
