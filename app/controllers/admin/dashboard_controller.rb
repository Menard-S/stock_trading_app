class Admin::DashboardController < Admin::BaseController
  def index
    @user = User.all
    @pending_users = User.where(status: :pending, role: 0)
    @approved_users = User.where(status: :approved, role: 0)
  end

  def create

  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(category_params)
      redirect_to @user, notice: "User was successfully updated."
    else
      render :edit
    end
  end

  def Show

  end

  private

  def user_params
    params.require(:user).permit(:email, :yob)
  end


end
