class ContestsController < ApplicationController
  ensure_authenticated_to_facebook
  before_filter :setup_contest, :only => [:index,:show]
  
  def index
    render :action => :show
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
    @competing_captions = @photo.captions.by_last_added(@photo.winning_caption)
  end
end
