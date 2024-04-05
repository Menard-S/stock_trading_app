class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :home_index_action?
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected

  def home_index_action?
    controller_name == 'home' && action_name == 'index'
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :yob, :asset])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :yob, :asset])
  end
end
