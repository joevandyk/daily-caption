
class CaptionPublisher < Facebooker::Rails::Publisher
  include ApplicationHelper

  def caption_feed caption
    caption_url = caption_url(caption)
    send_as :action
    from caption.user.facebook_session.user
    title "<fb:fbml> #{ name(caption.user.facebook_session.user)} captioned a #{ link_to 'photo', caption_url }</fb:fbml>"
    body  "<fb:fbml> #{ caption.caption } </fb:fbml>"
    add_image caption.photo.medium, caption_url
  rescue StandardError
    nil
  end
end

