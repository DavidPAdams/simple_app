module SessionsHelper
  # logs in a given user
  def log_in(user)
    session[:user_id] = user.id
  end
  #returns the current logged-in user if any
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end
  #returns boolean status of a logged in user
  def logged_in?
    !current_user.nil?
  end
end
