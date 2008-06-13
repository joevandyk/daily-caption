# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def add_caption_link
  "<div class='add-caption-link'>[ #{link_to "Add your own caption", new_caption_url} ]</div>"
  end
  
  def show_fold?
    params[:controller] == "contests" and @photo and !@photo.captions.empty?
  end
  
  def show_add_caption?(photo)
    photo.captioning? and params[:action] != "new"
  end

  def caption_before_deadline_text caption
    photo = caption.photo
    time = distance_of_time_in_words caption.created_at, photo.ended_captioning_at
    "#{ time } before the deadline"
  end
  
  def caption_share_button(caption)
    <<-eos
      <fb:share-button class="meta">
        <meta name="title" content="#{caption.caption}"/>
        <meta name="description" content="Help vote up this caption! Think you are funnier?? Write your own caption on DailyCaption!"/>
        <link rel="image_src" href="#{caption.photo[:small]}"/>
        <link rel="target_url" href="#{caption_url(caption)}"/> 
      </fb:share-button>
    eos
  end
  
  def current_tab?(tab)
    tab == @current_tab
  end
  
  def current_uri
    request.protocol << request.host_with_port << request.request_uri
  end
  
  def link_to_unless_sorting_by(name, options, html_options = {}, *parameters_for_method_reference, &block)
      options.merge(:anchor => "captions")
      link_to_unless params[:sort] == options[:sort], name, options, html_options, *parameters_for_method_reference, &block
  end

  def name(user,options={})
    fb_name(user.site_user_id,{:ifcantsee=>"A Hidden User"}.merge(options))
  end
  
  def photo_cont photo, &block
    concat(render(:partial => "contests/photo", :locals => {:body => capture(&block), :photo => photo}), block.binding)
  end
    
  def profile_pic(user, size=:thumb)
    fb_profile_pic user.site_user_id, :size => size
  end
  
  def profile_section options
    render :partial => "users/profile_section", :locals => options
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
  
  def time_left
    "Time Left: <strong>#{ time_until_next_contest }</strong> <small>(until 12:00AM UTC)</small>"
  end
  
  def time_until_next_contest
    distance_of_time_in_words(Time.now, Photo.current.ended_captioning_at, include_seconds = true)
  end
  
end
