class UsersController < ApplicationController
  MINIMUM_CREDITS = -5
  
  before_filter :authenticate_admin!, :except => [:index, :show, :new, :click, :create]
  
  def all_users
    @users ||= User.ordered_by_credits.to_a
  end
  
  def clickable_users(users)
    @clickables ||= users.select { |u| u.credits > MINIMUM_CREDITS && !u.legend }.to_a
  end
  
  def legend_users(users)
    @legends ||= @users.select {|u| u.legend }.to_a
  end
  
  def sorted_users(users)
    @sorted_by_name ||= users.sort { |a,b| a.name.downcase <=> b.name.downcase }
  end
  
  # GET /users
  # GET /users.xml
  def index
    @users ||= User.ordered_by_credits.to_a
    clickable_users(@users)
    legend_users(@users)
    sorted_users(@users)
    # @users.sort! { |a,b| a.name.downcase <=> b.name.downcase }
    
    unless session[:current_user].blank?
      process_clicks
    end
    
    session.delete(:current_user)
    @selected_user = nil
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end
  
  # GET /users/inactive
  # GET /users.xml
  def frozen
    @users ||= User.frozen_users.to_a
    
    respond_to do |format|
      format.html # frozen.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(users_path, :notice => @user.name + ' was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => @user.name + ' was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy
  
    respond_to do |format|
      format.html { redirect_to :back, :notice => @user.name + ' was successfully deleted.' }
      format.xml  { head :ok }
    end
  end
  
  # DELETE /users/
  # DELETE /users/
  def destroy_frozen
    deleted = User.delete_frozen
    
    respond_to do |format|
      format.html { redirect_to :back, :notice => "#{helpers.pluralize(deleted, 'inactive user was', 'inactive users were')} successfully deleted." }
      format.xml  { head :ok }
    end
  end
  
  # POST /users/1/click
  # POST /users/1/click.xml
  def click
    @user = User.find(params[:id])
    all_users
    clickable_users(@users)
    @next_user = @clickables[@clickables.index(@user) + 1]
    
    if !params[:user].blank? && !params[:user][:id].blank?
      session[:current_user] = params[:user][:id]
    end
    
    if !session[:current_user].blank? && @selected_user.nil?
      @selected_user ||= User.find(session[:current_user])
    else
      flash[:error] = 'You must select a user.'
      redirect_to :action => 'index'
      return
    end
    
    # debugger
    if !params[:clicked_user].blank? && session[:current_user] != params[:clicked_user]
        @clicked_user ||= User.find(params[:clicked_user])
    end
    
    if @clicked_user
      process_clicks
    end
    
    if params[:commit] == 'End Clicking'
      redirect_to :action => 'index' and return
    end
    
    
    respond_to do |format|
      format.html # click.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  def process_clicks    
    case params[:commit]
    when 'Next User'
      @clicked_user.transaction do
        @selected_user.transaction do
        @clicked_user.lose_credit
        @selected_user.gain_credit
      end
      end
      flash.now[:notice] = 'Successfully clicked ' + @clicked_user.name + '.'
    when 'End Clicking'
      @clicked_user.transaction do
        @selected_user.transaction do
        @clicked_user.lose_credit
        @selected_user.gain_credit
      end
      end
      flash[:notice] = 'Successfully clicked ' + @clicked_user.name + '.'
    when 'Skip User'
      flash.now[:error] = 'Skipped ' + @clicked_user.name + '.'
    end
  end
end
