module ApplicationHelper
  
  # Return a title on a per-page basis.
  def title
    base_title = 'DarkClicker' 
    
    if @title.blank?
      @title = base_title
    else 
      "#{base_title} | #{@title}"
    end
  end
  
  def sortable(column, title = nil)
    title ||= column.titleize
    direction = column == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, :sort => column, :direction => direction
  end
  
end
