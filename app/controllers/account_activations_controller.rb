class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    # if user && !user.activated? && user.authenticated?(:activation, params[:id]) - This is the line from the tutorial, but the second condition didn't work, so I took it out
    if user && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:warning] = "Account was not activated"
      redirect_to root_url
    end
  end

end

