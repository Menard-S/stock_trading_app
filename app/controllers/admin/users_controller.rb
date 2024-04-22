class Admin::UsersController < Admin::BaseController

  before_action :set_user, only: [:edit, :update, :show, :activate_user, :reject_user]

  def index
    @trader = User.all
    @transactions = Transaction.all
  end

  def new
    @trader = User.new
  end

  def create
    new_user_params = params.require(:user).permit(:email, :name)

    if new_user_params[:email].blank? || new_user_params[:name].blank?
      flash[:alert] = 'Email and name cannot be empty.'
      redirect_to admin_dashboard_path
      return
    end

    existing_user = User.find_by(email: new_user_params[:email])
    if existing_user
      flash[:alert] = 'This user is already registered.'
      redirect_to admin_dashboard_path
      return
    end

    if params[:commit] == "Invite Trader"
      new_user_params[:yob] = 1900 # Placeholder year 
      new_user_params[:asset] = 0 # Placeholder year 
    end

    @invited_user = User.invite!(new_user_params) do |invitee|
    invitee.skip_invitation = true 
    end

    if @invited_user.errors.empty?
      UserMailer.user_invitation(@invited_user, invitation_link_url(@invited_user)).deliver_now
      redirect_to admin_dashboard_path, notice: 'Trader was successfully invited.'

    else
      render :new
    end
  end  
  

  def edit

  end

  def update
    if @user.update(user_params)
      redirect_to admin_dashboard_path, notice: "Trader was successfully updated."
    else
      render :edit
    end
  end

  def show
    @transactions = @user.transactions
  end

  def activate_user
    if @user.update(status: :approved)
      UserMailer.account_activation(@user).deliver_now
      redirect_to admin_dashboard_path, notice: "User activated successfully and notification sent."
    else
      redirect_to admin_dashboard_path, alert: "There was a problem activating the user."
    end
  end

  def reject_user
    if @user.destroy
      redirect_to admin_dashboard_path, notice: "User was successfully rejected."
    else
      redirect_to admin_dashboard_path, alert: "There was a problem rejecting the user."
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

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :name, :yob)
  end

  def trader_params
    params.require(:user).permit(:email, :name, :yob)
  end
  
  def invitation_link_url(user)
    accept_invitation_url(token: user.invitation_token)
  end
end