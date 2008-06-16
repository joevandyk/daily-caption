class VotesController < ApplicationController
  before_filter :ensure_installed
  def create
    @caption = Caption.find params[:caption_id]
    if @caption.votes.create :user => current_user
      if request.xhr?
        @caption.reload
        render :json => { :votes => @caption.votes.size }
        return false
      else
        redirect_to index_url
        return false
      end
      update_fb_profile(current_user)
      update_fb_profile(@caption.user) if current_user != @caption.user
    end
  end

  def index
    @user = User.find params[:user_id]
    @captions = @user.votes_given_captions
  end

end
