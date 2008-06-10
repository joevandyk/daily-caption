class VotesController < ApplicationController
  before_filter :ensure_installed
  def create
    @caption = Caption.find params[:caption_id]
    @caption.votes.create! :user => current_user
    if request.xhr?
      @caption.reload
      render :json => { :votes => @caption.votes.size }
    else
      redirect_to index_url
    end
  end

  def index
    @user = User.find params[:user_id]
    @captions = @user.voted_captions
  end

end
