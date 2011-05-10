class Admin::ConfigurablesController < ApplicationController
  # include the engine controller actions
  include ConfigurableEngine::ConfigurablesController

  # add your own filter(s) / layout
  before_filter :authenticate_admin!
  #layout 'admin'
end