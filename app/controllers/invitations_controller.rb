class InvitationsController < ApplicationController
  def new
    @from_user_id = session[:facebook_session].user.to_s
  end
  
  def create 
    @sent_to_ids = params[:ids] 
  end 
end
