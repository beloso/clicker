module ApplicationHelper
  
  def logged_in?
    session[:logged_in] == true
  end
  
  # Return a title on a per-page basis.
  def title
    base_title = "DarkClicker" 
    
    if @title.nil?
      @title = base_title
    else 
      "#{base_title} | #{@title}"
    end
  end
end
