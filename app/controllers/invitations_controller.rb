class InvitationsController < ApplicationController
  before_filter :ensure_installed
  def new
    @from_user_id = current_user.to_s
    update_fb_profile(current_user)
    @current_tab = :invites
  end
  
  def create 
    @sent_to_ids = params[:ids] 
  end 
end
