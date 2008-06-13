class InvitationsController < ApplicationController
  def new
    @from_user_id = session[:facebook_session].user.to_s
    update_fb_profile(current_user)
  end
  
  def create 
    @sent_to_ids = params[:ids] 
  end 
end
