class CustomFailureApp < Devise::FailureApp
    def respond
      if http_auth?
        http_auth
      else
        flash[:alert] = i18n_message unless flash[:notice]
        redirect_to root_path
      end
    end
  end  