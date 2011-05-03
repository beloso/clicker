module ApplicationHelper
  
  # Return a title on a per-page basis.
  def title
    base_title = 'DarkClicker' 
    
    if @title.blank?
      @title = base_title
    else 
      '#{base_title} | #{@title}'
    end
  end
end
