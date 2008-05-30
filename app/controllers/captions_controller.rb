class CaptionsController < ApplicationController
  def create
    c = Caption.create! :photo => Photo.find(params[:photo_id]), :user => current_user, :caption => params[:caption]
    redirect_to root_path(:format => :fbml)
  end
end
