######################################################################################
# Copyright (C) 2007 Eric Harris-Braun (eric -at- harris-braun.com), et al
# This software is distributed according to the license at 
# http://openmoney.info/licenses/rubycc
######################################################################################

class OmContextsController < ApplicationController
  include OpenMoneyHelper
  # GET /om_contexts
  # GET /om_contexts.xml
  def index
    @om_contexts = current_user.om_contexts
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @om_contexts }
    end
  end

  # GET /om_contexts/1
  # GET /om_contexts/1.xml
  def show
    @om_context = OmContext.find(params[:id])
    if current_user_or_can?(:manage_users,@om_context)
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @om_context }
      end
    end
  end

  # GET /om_contexts/new
  # GET /om_contexts/new.xml
  def new
    @om_context = OmContext.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @om_context }
    end
  end

  # GET /om_contexts/1/edit
  def edit
    @om_context = OmContext.find(params[:id])
    current_user_or_can?(:manage_users,@om_context)
    setup_return_to(:edit_contexts_return_to)
    setup_credentials_for_edit(@om_context)
  end

  # POST /om_contexts
  # POST /om_contexts.xml
  def create
    @om_context = OmContext.new(params[:om_context])
    @om_context.user_id = current_user.id
    @om_context.credentials = {:tag => params[:tag], :password => params[:password]}.to_yaml

    begin
      c = Context.find_by_omrl(@om_context.omrl)
    rescue Exception => e
      @om_context.errors.add(:omrl, "context could not be accessed (#{e.to_s})")
    end

    respond_to do |format|
      if c && @om_context.save
        flash[:notice] = 'Context was successfully accessed.'
        format.html { redirect_to(om_contexts_url) }
        format.xml  { render :xml => @om_context, :status => :created, :location => @om_context }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @om_context.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /om_contexts/1
  # PUT /om_contexts/1.xml
  def update
    @om_context = OmContext.find(params[:id])
    if current_user_or_can?(:manage_users,@om_context)
      
      @om_context.attributes = params[:om_context]
      respond_to do |format|
        return_url = session[:edit_context_return_to] || om_contexts_url
        if @om_context.save
          flash[:notice] = 'Context was successfully updated.'
          format.html { redirect_to(return_url) }
          format.xml  { head :ok }
          session[:edit_context_return_to] = nil
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @om_context.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /om_contexts/1
  # DELETE /om_contexts/1.xml
  def destroy
    @om_context = OmContext.find(params[:id])
    if current_user_or_can?(:manage_users,@om_context)
      @om_context.destroy

      respond_to do |format|
        format.html { redirect_to(om_contexts_url) }
        format.xml  { head :ok }
      end
    end
  end

  def make
  end
  
  def do_make
    @om_context = OmContext.new()
    handle_do_make(@om_context,'context','.',:CreateContext,om_contexts_url)
  end

end
