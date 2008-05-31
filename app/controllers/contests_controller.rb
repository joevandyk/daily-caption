class ContestsController < ApplicationController
  ensure_authenticated_to_facebook
  
  def index
    @past_photos = Photo.past.find(:all, :limit => 4)
    @photo = Photo.current
  end

end
