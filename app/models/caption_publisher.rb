
class CaptionPublisher < Facebooker::Rails::Publisher
  include ApplicationHelper

  def caption_feed caption
    send_as :action
    from caption.user.facebook_session.user
    title "<fb:fbml> #{ name(caption.user.facebook_session.user)} captioned a photo</fb:fbml>"
    body  "<fb:fbml> #{ caption.caption } </fb:fbml>"
  end
end

