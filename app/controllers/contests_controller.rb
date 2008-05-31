class ContestsController < ApplicationController
  ensure_authenticated_to_facebook
  
  def index
    #find captions	
    @photo = Photo.current
    @captions = @photo.captions
    @best_caption = @captions.shift
  end

end
