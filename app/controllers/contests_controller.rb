class ContestsController < ApplicationController
  ensure_authenticated_to_facebook
  before_filter :setup_contest, :only => [:index,:show]
  
  def index
    respond_to do |format|
      format.html { redirect_to facebook_page }
      format.fbml  { render :action => :show }
    end
  end
  
  def show    
  end
  
  def archive
    @photos = Photo.past.find(:all)
    @current_tab = :archive
  end
  
  private
  
  def setup_contest
    @photo = Photo.find(params[:id]) rescue Photo.current
    @current_tab = (@photo == Photo.current) ? :contest : :archive
    @competing_captions = case params[:sort]
      when "rank"	
        @photo.captions.by_rank(@photo.winning_caption)
      when "comments"
        @photo.captions.by_comments(@photo.winning_caption)
      else #time desc by default
        @photo.captions.by_last_added(@photo.winning_caption)
    end
  end
end
