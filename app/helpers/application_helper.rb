# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def current_uri
    request.protocol << request.host_with_port << request.request_uri
  end

  def show_media photo, size=:medium
    image_tag photo[size]
  end

  def name(user,options={})
    fb_name(user,{:ifcantsee=>"a hidden ninja"}.merge(options))
  end
end
