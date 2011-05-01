class UsersController < ApplicationController

  before_filter :authenticate, :except => [:index, :show, :new, :click, :create]
  
  # GET /users
  # GET /users.xml
  def index
    @users = User.order("(clicks_given - clicks_received) DESC")
    session[:current_user] = nil
    
    @title = "Listing Users"
                       
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    
    @title = "Viewing " + @user.name

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    @title = "Creating User"
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    
    @title = "Editing " + @user.name
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
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
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # /users/1/click
  # /users/1/click.xml
  def click
    @user = User.find(params[:id])
    
    @title = "Clicking " + @user.name
    
    @users_to_click = User.where("clicks_given - clicks_received >= ?", -5).order("clicks_given - clicks_received DESC")
    if session[:current_user] || params[:user][:id] && !params[:user][:id].blank?
      session[:current_user] ||= User.find(params[:user][:id])
    else
      flash[:alert] = "You must select a user."
      redirect_to :action => 'index'
      return
    end
    respond_to do |format|
      format.html # click.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy
  
    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end
