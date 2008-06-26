class CaptionsController < ApplicationController
  before_filter :ensure_installed, :except => [:show, :index]
  
  def create
    @photo = Photo.current
    @caption = Caption.create :photo => @photo, :user => current_user, :caption => params[:caption][:caption]
    if @caption.new_record?
      flash[:error] = show_errors_for_object(@caption) 
      render :action => "new"
    else
      update_fb_profile(current_user)
      redirect_to index_url(:anchor => dom_id(@caption))
    end
  end

  def index
    @user = User.find params[:user_id]
    @captions = @user.captions.paginate :page => params[:page]
  end
  
  def show
    @caption = Caption.find(params[:id])
    @current_tab = (@caption.photo.captioning?) ? :contest : :archive
  end
  
  def new
    @caption = Caption.new
    @photo = Photo.current
    @current_tab = :contest
  end
end
