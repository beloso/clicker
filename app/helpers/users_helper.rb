module UsersHelper
  def next_user_button
    @next_user = @users_to_click[@users_to_click.index(@user) + 1]
    button_to "Next User", 
              @next_user ? click_url(:id => @next_user.id) : {}, 
              :disabled => !@next_user;
  end
  
  def end_clicking_button
    button_to "End Clicking", users_path, :method => :get
  end
  
  def current_user_selector
    collection_select(:user, :id, @users, :id, :name, {:prompt => "Select a User"});
  end
  
  def get_current_user
    session[:current_user] = User.find(params[:user][:id]);
  end
  
  def start_clicking_button    
    button_to "Start Clicking",
              @users.first ? click_url(:id => @users.first.id) : {},
              :disabled => !@users.first;
  end
  
  def render_view
    session[:current_user] ||= User.find(params[:user][:id]);
    
    respond_to do |format|
      format.html # click.html.erb
      format.xml  { render :xml => @user }
    end 
  end
end
