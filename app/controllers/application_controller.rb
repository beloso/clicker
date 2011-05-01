class ApplicationController < ActionController::Base
  protect_from_forgery
  
  USER, PASSWORD = 'admin', 'admin'
  
  def authenticate
     authenticate_or_request_with_http_basic do |user, password|
      user == 'admin' && password == 'pass' && session[:logout_requested] != true
      session[:logged_in] = true
      session[:logout_requested] = nil
      flash[:alert] = "You have been logged in."
      redirect_to :controller => 'users', :action => 'index' and return
    end  
  end
    
  def destroy
      session[:logout_requested] = true
      session[:logged_in] = false
      flash[:notice] = "You have logged out successfully"
      redirect_to(root_path)
  end
end