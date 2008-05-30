# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def show_media photo
    image_tag photo.medium
  end

end
