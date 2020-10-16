class FilterParamsController < ApplicationController
  load_and_authorize_resource

  include ComboTable
  helper_method :sort_column, :sort_direction
  combo_table :filter_param , :columns => [:filter_param_type, :column, :optionable_id, :optionable_type]

  set_tab :analytics
  set_tab :filter_params, :sub_nav
  before_filter do
    @sub_nav_group = :analytics
  end

  # let ComboTable handle rendering
  ## GET /filter_params
  ## GET /filter_params.xml
  #def index
  #  respond_to do |format|
  #    format.html # index.html.erb
  #    format.xml  { render :xml => @filter_params }
  #  end
  #end

  # GET /filter_params/1
  # GET /filter_params/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @filter_param }
    end
  end

  # GET /filter_params/new
  # GET /filter_params/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @filter_param }
    end
  end

  # GET /filter_params/1/edit
  def edit
  end

  # POST /filter_params
  # POST /filter_params.xml
  def create
    respond_to do |format|
      if @filter_param.save
        format.html { redirect_to(filter_params_path, :notice => 'Filter param was successfully created.') }
        format.xml  { render :xml => @filter_param, :status => :created, :location => @filter_param }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @filter_param.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /filter_params/1
  # PUT /filter_params/1.xml
  def update
    respond_to do |format|
      if @filter_param.update_attributes(params[:filter_param])
        format.html { redirect_to(filter_params_path, :notice => 'Filter param was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @filter_param.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /filter_params/1
  # DELETE /filter_params/1.xml
  def destroy
    @filter_param.destroy

    respond_to do |format|
      format.html { redirect_to(filter_params_url) }
      format.xml  { head :ok }
    end
  end
end
