# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def advertisement ad_slot,width,height
    <<-eos
    <script type="text/javascript"><!--
    google_ad_client = "pub-2921896918877269";
    google_ad_slot = "#{ad_slot}";
    google_ad_width = #{width};
    google_ad_height = #{height};
    //-->
    </script>
    <script type="text/javascript" src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
    </script>
    eos
  end
  
  def iframe_ad ad_slot,width,height
    if should_show_ads?
      "<fb:iframe src='#{ad_server_url(:ad_slot => ad_slot, :width => width, :height => height, :canvas => false, :only_path => false)}' width='#{width}' height='#{height}' border='0' scrolling='no' frameborder=0></fb:iframe>"
    end
  end
  
  def ad_social_media width='645', height='60'
    if should_show_ads?
      <<-eos
      <fb:iframe src='http://ads.socialmedia.com/facebook/monetize.php?width=#{width}&height=#{height}&pubid=7a1b13d3bfc36c4f0792887fff11c541&pop=1&bgcolor=F7F7F7&textcolor=000&bordercolor=F6F6F6&linkcolor=3B5998&fb_sig_user=#{current_user.facebook_user.id}' border='0' width='#{width}' height='#{height}' resizable='false' name='socialmedia_ad' scrolling='no' frameborder='0'></fb:iframe>
      <fb:iframe src='http://adtracker.socialmedia.com/track/' width='1' height='1' style='display:none;' />
      eos
    end
  end
  
  def google_analytics
    "<fb:google-analytics uacct='UA-887439-9'' />"
  end
  
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
      link_to_unless @sort == options[:sort], name, options, html_options, *parameters_for_method_reference, &block
  end

  def name(user,options={})
    link_to_unless_current(name_only(user, options), user_url(user))
  end

  def name_only user, options={}
    fb_name(user.site_user_id, { :ifcantsee => "A Hidden User", :linked => false }.merge(options))
  end
  
  def first_name user,options={}
    fb_name(user.site_user_id,{:possessive => true, :firstnameonly => true, :linked => false, :useyou => false}.merge(options))
  end
  
  def first_name_linked user, options={}
    fb_name(user.site_user_id,{:firstnameonly => true, :useyou => false}.merge(options))
  end
  
  def photo_cont photo, &block
    concat(render(:partial => "contests/photo", :locals => {:body => capture(&block), :photo => photo}), block.binding)
  end
    
  def profile_pic(user, size=:thumb)
    link_to_unless_current(fb_profile_pic(user.site_user_id, :size => size, :linked => false), user_url(user))
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
  
  def on_profile_page?
    params[:controller] == "users" and params[:action] == "show"
  end
  
  private
  
  def should_show_ads?
    RAILS_ENV == "production"
  end
  
end
