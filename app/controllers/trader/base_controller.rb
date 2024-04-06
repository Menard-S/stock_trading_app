class Trader::BaseController < ApplicationController

    before_action :set_user
    before_action :set_asset_balance
    before_action :restrict_access_for_admin

    private

    def set_user
      @user = current_user
    end

    def set_asset_balance
      @asset_balance = calculate_adjusted_asset_balance(@user)
    end

    def calculate_adjusted_asset_balance(user)
      adjusted_balance = user.asset
      Rails.logger.debug "Starting balance: #{adjusted_balance}"
    
      user.transactions.each do |transaction|
        price_change = transaction.transaction_price * transaction.share
        if transaction.transaction_type == 'sell'
          adjusted_balance += price_change
        else
          adjusted_balance -= price_change
        end
    
        Rails.logger.debug "Transaction: #{transaction.transaction_type}, Price Change: #{price_change}, New Balance: #{adjusted_balance}"
      end
    
      adjusted_balance
    end

    def restrict_access_for_admin
      if current_user.admin?
        redirect_to root_path, alert: 'RA NO. 8799 GRAVE VIOLATION: You are holding insider data! You are prohibited from trading on the platform.'
      end
    end
    
  end
