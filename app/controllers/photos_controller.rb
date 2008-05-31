class PhotosController < ApplicationController
  def show
    @photo = Photo.past.find params[:id]
  end
end
