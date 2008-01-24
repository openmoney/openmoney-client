class PlaysController < ApplicationController
  require_authentication  
  before_filter :setup_sections
  
  # GET /plays
  # GET /plays.xml
  def index
    @plays = Play.find(:all)

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
    @play.status = 'pending'
    @play.end_date = @play.start_date if !params[:date_range]
    respond_to do |format|
      if @play.save
        flash[:notice] = 'Play was successfully created.'
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
        flash[:notice] = 'Play was successfully updated.'
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
        flash[:notice] = 'Play was successfully approved.'
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
    @header="open play" 
    @sections = SectionsOpenPlay
    @current_section = 'plays'
    true
  end
  
end
