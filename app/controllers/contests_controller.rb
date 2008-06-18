class ContestsController < ApplicationController
  ensure_authenticated_to_facebook
  before_filter :setup_contest, :only => [:index,:show]
    
  def index
    respond_to do |format|
      format.fbml  { render :action => :show }
      format.html { redirect_to facebook_page }
    end
  end
  
  def show    
  end
  
  def archive
    @photos = Photo.past.paginate :page => params[:page]
    @current_tab = :archive
  end
  
  private
  
  def setup_contest
    @photo = Photo.find(params[:id]) rescue Photo.current
    @current_tab = @photo.current? ? :contest : :archive
    
    default_sort = @photo.current? ? "time" : "rank" 
    @sort = params[:sort] || default_sort
    @competing_captions = case @sort
      when "rank"	
        @photo.captions.by_rank(@photo.winning_caption).paginate :page => params[:page]
      when "comments"
        @photo.captions.by_comments(@photo.winning_caption).paginate :page => params[:page]
      when "time"
        @photo.captions.by_last_added(@photo.winning_caption).paginate :page => params[:page]
    end
  end
end
