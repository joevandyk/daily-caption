module Admin::PhotosHelper
  def flickr_id_if_first_text_field(counter)
    params[:flickr_id] if params[:flickr_id] and counter == 1
  end
end
