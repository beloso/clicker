class AdminsController < ApplicationController
    
  before_filter :authenticate_admin!
  
  helper_method :sort_column, :sort_direction
  
  # GET /admins
  # GET /admins.xml
  def index
    @admins = Admin.select('*').order(sort_column + " " + sort_direction)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admins }
    end
  end
  
  def search
    @admins ||= Admin.where("name LIKE ?","%#{params[:search]}%").order(sort_column + " " + sort_direction)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
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
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  # GET /admins/1/edit
  def edit
    @admin = Admin.find(params[:id])
  end

  # POST /admins
  # POST /admins.xml
  def create
    @admin = Admin.new(params[:admin])

    respond_to do |format|
      if @admin.save
        format.html { redirect_to(admins_path, :notice => @admin.name + ' was successfully created.') }
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
    if params[:admin][:password].blank?
      params[:admin].delete(:password)
    end
    
    if @admin.id == 1 && @admin != current_admin
      flash[:error] = 'You can not edit ' + @admin.name
      redirect_to @admin and return
    end
    
    respond_to do |format|
      if @admin.update_attributes(params[:admin])
        sign_in(@admin, :bypass => true) if @admin == current_admin
        format.html { redirect_to(@admin, :notice => @admin.name + ' was successfully updated.') }
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
    
    if @admin.id == 1
      respond_to do |format|
        format.html { flash[:error] = "You can not delete the root admin.";
                      redirect_to(admins_url) }
        format.xml  { head :ok }
      end and return
    end
    
    @admin.destroy

    respond_to do |format|
      format.html { redirect_to(admins_url, :notice => @admin.name + ' was successfully deleted.') }
      format.xml  { head :ok }
    end    
  end
  
  # DELETE /users/
  # DELETE /users/
  def destroy_selected
    params[:admin_ids].delete('1')
    if params[:admin_ids]
      deleted = Admin.delete_all(:id => params[:admin_ids])
    end
    
    respond_to do |format|
      format.html { redirect_to :back, :notice => "#{helpers.pluralize(deleted, 'user was', 'users were')} successfully deleted." }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def sort_column
    columns ||= Admin.column_names.include?(params[:sort]) ? params[:sort] : 'name'
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end
  
end
