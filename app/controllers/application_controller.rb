class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def login_verify             
    session_expire_check       
    if session[:user_id] != nil
      @current_user = User.find(:first, :conditions => { :id => session[:user_id] })
    end
  end 

  def session_expire_check     
    reset_session if session[:last_seen] == nil or session[:last_seen] < 100.days.ago
  end


end
