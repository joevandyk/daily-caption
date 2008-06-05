# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def current_tab?(tab)
    tab == @current_tab
  end
  
  def current_uri
    request.protocol << request.host_with_port << request.request_uri
  end
  
  def link_to_new_caption_form link
    link_to_function(link,"$('new-caption').toggleClassName('hidden');")
  end

  def name(user,options={})
    fb_name(user.site_user_id,{:ifcantsee=>"a hidden ninja"}.merge(options))
  end
  
  def profile_pic(user)
    fb_profile_pic user.site_user_id
  end
    
  def relative_day(datetime)
    date = datetime.to_date
    today = Time.now.to_date
    if date == today
      "Today"
    elsif date == (today - 1)
      "Yesterday"
    elsif date == (today + 1)
      "Tomorrow"
    else
      datetime.to_s(:day)
    end
  end
  
  def show_media photo, size=:medium
    image_tag photo[size]
  end
  
  def sortable_captions?(competing_captions)
    competing_captions.size >= 2
  end
  
  def time_until_next_contest
    distance_of_time_in_words(Time.now, Time.now.tomorrow.at_beginning_of_day, include_seconds = true)
  end
end
