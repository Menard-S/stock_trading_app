class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [:edit, :update, :show, :activate_user, :deactivate_user,]

  def index
    @trader = User.all
    @transactions = Transaction.all
  end

  def new
    @trader = User.new
  end

  def create
    @trader = User.new(trader_params.merge(invited_by_admin: true))
    @trader.password = Devise.friendly_token.first(8) # Generate a random password
    
    if @trader.save
      UserMailer.invitation_email(@trader).deliver_now
      redirect_to admin_dashboard_path, notice: 'Trader was successfully created.'
    else
      render :new
    end
  end

  def edit
    # @user = User.find(params[:id])
  end

  def update
    # @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_dashboard_path, notice: "Trader was successfully updated."
    else
      render :edit
    end
  end

  def show
    @user = User.find(params[:id])
    @transactions = @user.transactions

  end

  def activate_user
    # user = User.find(params[:id])
    if user.update(status: :approved)
      UserMailer.account_activation(user).deliver_now
      redirect_to admin_dashboard_path, notice: "User activated successfully and notification sent."
    else
      redirect_to admin_dashboard_path, alert: "There was a problem activating the user."
    end
  end

  def deactivate_user
    # @user = User.find(params[:id])
    @user.deactivate! # Assuming you have a deactivate method in your User model
    redirect_to admin_dashboard_path, notice: "User deactivated successfully."
  end

  def transactions
    @user = User.find_by(id: params[:id])
    # puts "@user: #{@user.inspect}"
    if @user
      @transactions = @user.transactions
    else
      flash[:alert] = "User not found"
      redirect_to admin_users_path
    end
    # @transactions = @user.transactions
    # puts "@transactions: #{@transactions.inspect}"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :name, :yob)
  end

  def trader_params
    params.require(:user).permit(:email, :name, :yob)
  end
end