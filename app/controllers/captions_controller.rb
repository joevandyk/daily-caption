class CaptionsController < ApplicationController
  before_filter :ensure_installed
  def create
    c = Caption.create :photo => Photo.find(params[:photo_id]), :user => current_user, :caption => params[:caption][:caption]
    raise c.errors.full_messages.inspect if c.new_record?
    redirect_to index_url
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
