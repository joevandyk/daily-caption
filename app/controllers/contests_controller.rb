class ContestsController < ApplicationController
  ensure_authenticated_to_facebook
  
  def index
    #find captions	
    @photo = Photo.current
    @best_caption = @photo.winning_caption
    @captions = @photo.captions.by_last_added(@best_caption)
  end

end
