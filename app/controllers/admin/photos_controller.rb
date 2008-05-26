class Admin::PhotosController < Admin::AdminController
  def new
  end

  def index
    @recently_submitted_photos = Photo.find_in_state(:all, 'submitted')
    @ready_for_captioning_photos = Photo.find_in_state(:all, 'ready_for_captioning')
  end

  def create
    count = Photo.create_in_bulk params[:photos]
    flash[:notice] = "#{count} photos created"
    redirect_to new_admin_photo_path
  end
end
