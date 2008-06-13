class CaptionsController < ApplicationController
  before_filter :ensure_installed
  def create
    c = Caption.create :photo => Photo.find(params[:photo_id]), :user => current_user, :caption => params[:caption][:caption]
    flash[:error] = show_errors_for_object(c) if c.new_record?
    redirect_to new_caption_url
  end

  def index
    @user = User.find params[:user_id]
    @captions = @user.captions
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
