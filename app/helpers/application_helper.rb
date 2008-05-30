# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def current_uri
    request.protocol << request.host_with_port << request.request_uri
  end

  def show_media photo, size=:medium
    image_tag photo[size]
  end
  
  def link_to_new_caption_form link
    link_to_function(link,"$('new-caption').toggleClassName('hidden');")
  end
end
