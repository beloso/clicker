class Admin::ConfigurablesController < ApplicationController
  # include the engine controller actions
  include ConfigurableEngine::ConfigurablesController

  # add your own filter(s) / layout
  before_filter :authenticate_admin!
  #layout 'admin'
  
  def show
    
  end
  
  def update
    Configurable.keys.each do |key|
      Configurable.find_or_create_by_name(key).
                   update_attribute(:value,params[key])
    end
    redirect_to admin_configurable_path, :notice => 'Configurations Saved'
  end
end