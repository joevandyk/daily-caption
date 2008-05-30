class CaptionsController < ApplicationController
  def create
    c = Caption.create! :photo => Photo.find(params[:photo_id]), :user => current_user, :caption => params[:caption][:caption]
    redirect_to index_url
  end
end
