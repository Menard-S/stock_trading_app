class Admin::UsersController < Admin::BaseController
  before_action 
  def activate_user
    user = User.find(params[:id])
    if user.update(status: :approved)
      UserMailer.account_activation(user).deliver_now
      redirect_to admin_dashboard_path, notice: "User activated successfully and notification sent."
    else
      redirect_to admin_dashboard_path, alert: "There was a problem activating the user."
    end
  end

  def index
    @trader = User.all
    @transactions = Transaction.all
  end

  def new
    @trader = User.new
  end

  def create
    @trader = User.new(trader_params)
    if @trader.save
      UserMailer.verification_link(@trader).deliver_now
      redirect_to admin_dashboard_path, notice: 'Trader was successfully created.'
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_dashboard_path, notice: "Trader was successfully updated."
    else
      render :edit
    end
  end

  def transactions
    @user = User.find_by(id: params[:id])
    if @user
      @transactions = @user.transactions
    else
      flash[:alert] = "User not found"
      redirect_to admin_users_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :name, :yob)
  end

  private

  def trader_params
    params.require(:trader).permit(:email, :name, :yob, :asset, :password, :password_confirmation)
  end
end