######################################################################################
# Copyright (C) 2007 Eric Harris-Braun (eric -at- harris-braun.com), et al
# This software is distributed according to the license at 
# http://openmoney.info/licenses/rubycc
######################################################################################

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_rubycc_session_id'
  enable_authentication :user_model => User
  enable_authorization
  require_authentication
  Rauth::Source::Native.rauth_options.update({
    :min_pass_length  => 4,
    :pass_error_msg   => 'Password must be at least 4 characters long',
    })


  protected
  
  def current_user_or_can?(permission = nil,obj = nil)
    the_id = obj ? obj.user_id : params[:id].to_i
#    raise "((#{the_id} == #{current_user.id}) || (#{!permission} || #{current_user.can?(permission)}))"
    if (the_id == current_user.id) || (!permission || current_user.can?(permission))
      true
    else
      respond_to do |format|
        flash[:notice] = 'Not allowed!'
        format.html { redirect_to( home_url) }
        format.xml  { head :failure }
      end
      false
    end
  end

end
