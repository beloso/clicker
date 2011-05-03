class AdminsController < ApplicationController
    
  before_filter :authenticate_admin!
  
  # GET /admins
  # GET /admins.xml
  def index
    @admins = Admin.all       
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admins }
    end
  end
  
  # GET /admins/1
  # GET /admins/1.xml
  def show
    @admin = Admin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @admin }
    end
  end
  
  # GET /admins/new
  # GET /admins/new.xml
  def new
    @admin = Admin.new
    @title = "Creating Admin"
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  # GET /admins/1/edit
  def edit
    @admin = Admin.find(params[:id])
    
    @title = "Editing " + @admin.name
  end

  # POST /admins
  # POST /admins.xml
  def create
    @admin = Admin.new(params[:admin])

    respond_to do |format|
      if @admin.save
        format.html { redirect_to(@admin, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @admin, :status => :created, :location => @admin }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admins/1
  # PUT /admins/1.xml
  def update
    @admin = Admin.find(params[:id])

    respond_to do |format|
      if @admin.update_attributes(params[:admin])
        # Line below required if using Devise >= 1.2.0
        sign_in(@admin, :bypass => true) if @admin == current_admin
        format.html { redirect_to(@admin, :notice => 'Admin was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /admins/1
  # DELETE /admins/1.xml
  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy
  
    respond_to do |format|
      format.html { redirect_to(admins_url, :notice => 'Admin was successfully deleted.') }
      format.xml  { head :ok }
    end
  end
  
end
