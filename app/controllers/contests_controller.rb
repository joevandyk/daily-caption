class ContestsController < ApplicationController
  ensure_authenticated_to_facebook
  
  def index
    @photo = Photo.current
    render :action => :show
  end
  
  def show
    if @photo
      @current_tab = :contest
    else
      Photo.find(params[:id])
      @current_tab = :archive
    end
    @past_photos = Photo.past.find(:all, :limit => 4)
  end
  
  def archive
    @photos = Photo.past.find(:all)
    @current_tab = :archive
  end
end
