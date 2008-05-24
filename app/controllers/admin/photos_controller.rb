class Admin::PhotosController < Admin::AdminController
  def new
  end

  def index
    @recently_submitted_photos = Photo.find_in_state(:all, 'submitted')
    @edy_for_captioning_photos = Photo.find_in_state(:all, 'ready_for_captioning')
  end

  def create
    count = 0
    for flickr_id in params[:photos] do
      if ! flickr_id.blank?
        Photo.create! :flickr_id => flickr_id
        count += 1
      end
    end
    flash[:notice] = "#{count} photos created"
    redirect_to new_admin_photo_path
  end
end
