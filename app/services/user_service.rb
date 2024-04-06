class UserService < BaseService
  def update_asset(amount)
      @user.asset += amount
      @user.save!
    end
end