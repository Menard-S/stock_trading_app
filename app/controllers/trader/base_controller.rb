class Trader::BaseController < ApplicationController

    before_action :set_user
    before_action :set_asset_balance
    before_action :restrict_access_for_admin

    private

    def set_user
      @user = current_user
    end

    def set_asset_balance
      @asset_balance = @user.asset
    end

    def restrict_access_for_admin
      if current_user.admin?
        redirect_to root_path, alert: 'RA NO. 8799 GRAVE VIOLATION: You are holding insider data! You are prohibited from trading on the platform.'
      end
    end
  end
