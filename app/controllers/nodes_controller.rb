class NodesController < ApplicationController
  before_filter :setup_sections
  require_authentication(:except => [:index])
  # GET /nodes
  # GET /nodes.xml
  def index
    @nodes = Node.find(:all,:order => :lft)
    
    @node_list = []
    0.upto(@nodes.size-1) do |i|
      node = @nodes[i]
      links = []
      if i > 0
      	prev_node = @nodes[i-1]
      	if prev_node.level == node.level
          links << {:link_type=> :arrow_right, :to => 'child_of', :dest_id => prev_node}
      	end
      	if prev_node.level < node.level
          links << {:link_type=> :arrow_left, :to => 'right_of', :dest_id => prev_node}
      	end
        links << {:link_type=> :arrow_up, :to => 'left_of', :dest_id => prev_node}
      end
      if i < @nodes.size-1
        (i+1).upto(@nodes.size-1) do |n|
          if @nodes[n].level <= node.level
            links << {:link_type=> :arrow_down, :to => 'right_of', :dest_id => @nodes[n]}
            break
          end
        end
      end
      @node_list << [node,links]
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nodes }
    end
  end

  # GET /nodes/1
  # GET /nodes/1.xml
  def show
    @node = Node.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @node }
    end
  end

  # GET /nodes/new
  # GET /nodes/new.xml
  def new
    @node = Node.new
    @node.owner = current_user

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @node }
    end
  end

  # GET /nodes/1/edit
  def edit
    @node = Node.find(params[:id])
  end

  # POST /nodes
  # POST /nodes.xml
  def create
    @node = Node.new(params[:node])
    @node.modifier = current_user
    respond_to do |format|
      if @node.save
        @node.move_to_right_of(params[:insert_after_id]) if Node.exists?(params[:insert_after_id])
        flash[:notice] = 'Project was successfully created.'
        format.html { redirect_to(nodes_url) }
        format.xml  { render :xml => @node, :status => :created, :location => @node }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @node.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /nodes/1/move
  # PUT /nodes/1.xml
  def move
    @node = Node.find(params[:id])
    case params[:to]
    when 'left_of'
      @node.move_to_left_of(params[:dest_id])
    when 'right_of'
      @node.move_to_right_of(params[:dest_id])
    when 'child_of'
      @node.move_to_child_of(params[:dest_id])
    end
    @node.save
    redirect_to(nodes_url)
  end

  # PUT /nodes/1
  # PUT /nodes/1.xml
  def update
    @node = Node.find(params[:id])
    @node.modifier = current_user
    respond_to do |format|
      if @node.update_attributes(params[:node])
        flash[:notice] = 'Project was successfully updated.'
        format.html { redirect_to(nodes_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @node.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /nodes/1
  # DELETE /nodes/1.xml
  def destroy
    @node = Node.find(params[:id])
    @node.destroy

    respond_to do |format|
      format.html { redirect_to(nodes_url) }
      format.xml  { head :ok }
    end
  end
  
  def currency_omrls_select
    @node = Node.find(params[:id])
    render :partial => 'currency_omrls_select', :locals => { :account => @node.get_account }
  end
  
  protected
  def setup_sections
    @header="open play" 
    @sections = SectionsOpenPlay
    @current_section = 'projects'
  end
end
