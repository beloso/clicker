class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def helpers
      ActionController::Base.helpers
  end

  class Helper
    include Singleton
    include ActionView::Helpers::TextHelper
  end
end