class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user
      if user
        if user.authenticated?(:activation, params[:id])
          user.activate
          log_in user
          flash[:success] = "Account activated!"
          redirect_to user
        else
          flash[:danger] = "user couldn't be authenticated"
          redirect_to root_url
        end
      else
        flash[:info] = "Waaa, user is already activated?"
        redirect_to root_url
      end
    else
      flash[:warning] = "WTF? user is false"
      redirect_to root_url
    end
  end

end

