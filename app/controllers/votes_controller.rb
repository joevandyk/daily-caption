class VotesController < ApplicationController
  before_filter :ensure_installed
  def create
    @caption = Caption.find params[:caption_id]
    @caption.votes.create! :user => current_user
    redirect_to index_url
  end

end