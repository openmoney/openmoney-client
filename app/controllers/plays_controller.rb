class PlaysController < ApplicationController
  require_authentication  
  before_filter :setup_sections
  
  OrderMap = {
		'd'=> 'start_date',
		's'=> 'status',
		'n'=> 'last_name,first_name'
	}
	SearchFieldMap = {
		'u' => 'user_name',
		'p' => "concat(first_name,' ',last_name)", 
		'd' => 'description',
		's' => 'status',
		'c' => 'currency_omrl'
	}
  
  # GET /plays
  # GET /plays.xml
  def index
		options = search_options(:plays,SearchFieldMap,OrderMap,
		{"project_id"=>"0", "order"=>"n", "type"=>"my_proposed", "on"=>"u_is", "for"=>current_user, "on_s_is_n"=>"proposed"},
		's',:player,:project)
    @plays = Play.find(:all,options)

    if @search_params
      project_id = @search_params[:project_id].to_i
      if project_id > 0
        @project_id_list = [project_id]
        @project_id_list.concat(Node.find(project_id).all_children.collect {|n| n.id})
      end
    else
      @search_params = {}
    end

		if @search_params
      if @project_id_list
        @plays = @plays.reject {|p| !@project_id_list.include?(p.project.id)}
      end
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @plays }
    end
  end

  # GET /plays/1
  # GET /plays/1.xml
  def show
    @play = Play.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @play }
    end
  end

  # GET /plays/new
  # GET /plays/new.xml
  def new
    @play = Play.new
    @play.player = current_user
    @play.project = Node.root

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @play }
    end
  end

  # GET /plays/1/edit
  def edit
    @play = Play.find(params[:id])
    @is_range = @play.start_date != @play.end_date
  end

  # POST /plays
  # POST /plays.xml
  def create
    @play = Play.new(params[:play])
    @play.creator = current_user
    @play.status = 'proposed'
    @play.end_date = @play.start_date if !params[:date_range]
    respond_to do |format|
      if @play.save
        flash[:notice] = 'Contribution was successfully created.'
        format.html { redirect_to( plays_url) }
        format.xml  { render :xml => @play, :status => :created, :location => @play }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @play.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /plays/1
  # PUT /plays/1.xml
  def update
    @play = Play.find(params[:id])
    @play.attributes= params[:play]
    @play.end_date = @play.start_date if !params[:date_range]
    respond_to do |format|
      if @play.save
        flash[:notice] = 'Contribution was successfully updated.'
        format.html { redirect_to(plays_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @play.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /plays/1/approve
  # PUT /plays/1.xml
  def approve
    @play = Play.find(params[:id])
    respond_to do |format|
      errors = @play.approve
      if errors.empty?
        flash[:notice] = 'Contribution was successfully approved.'
        format.html { redirect_to(plays_url) }
        format.xml  { head :ok }
      else
        flash[:notice] = 'Error: ' << errors.inspect
        format.html { redirect_to(plays_url) }
        format.xml  { render :xml => @play.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /plays/1
  # DELETE /plays/1.xml
  def destroy
    @play = Play.find(params[:id])
    @play.destroy

    respond_to do |format|
      format.html { redirect_to(plays_url) }
      format.xml  { head :ok }
    end
  end
    
  protected
  def setup_sections
    @header="" 
    @sections = SectionsOpenPlay
    @current_section = 'contributions'
    true
  end
  
end
