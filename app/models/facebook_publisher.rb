
class FacebookPublisher < Facebooker::Rails::Publisher
  include ApplicationHelper

  def caption_action caption
    caption_url = caption_url(:id => caption.id)
    send_as :action
    from caption.facebook_user
    title "<fb:fbml> #{ name(caption.user.facebook_session.user)} captioned a #{ link_to 'photo', caption_url }</fb:fbml>"
    body  "<fb:fbml> #{ link_to caption.caption, caption_url(caption) } - Help vote up this caption on #{link_to "DailyCaption", index_url}!</fb:fbml>"
    add_image caption.photo.medium, caption_url
  rescue StandardError
    nil
  end

  def winning_caption_action caption
    send_as :action
    from caption.facebook_user
    title "<fb:fbml> #{ name(caption.user.facebook_session.user)} won a #{ link_to 'DailyCaption contest!', caption_url(:id => caption.id) }</fb:fbml>"
    body  "<fb:fbml> Winning caption: #{ caption.caption } </fb:fbml>"
    add_image caption.photo.medium, caption_url(:id => caption.id)
  end

  def notify_winner caption
    send_as :notification
    recipients caption.facebook_user
    from caption.facebook_user
    fbml  "<fb:fbml> Hooray, you won a Daily Caption contest with #{ caption.caption } </fb:fbml>"
  end

  def notify_caption_comment caption, comment
    send_as       :notification
    recipients    caption.facebook_user
    from          comment.facebook_user
    fbml          "<fb:fbml> Someone commented on your caption! #{ caption.caption } </fb:fbml>"
  end

  def email_winner caption
    send_as :email
    recipients caption.facebook_user
    from caption.facebook_user
    title "Congratulations on winning a Daily Caption contest!"
    fbml  "<fb:fbml> Woohoo! Here is your caption that won: #{ caption.caption } </fb:fbml>"
  end

  def winning_voters_action caption, user
    send_as :action
    from user
    title "<fb:fbml> #{ name(user)} voted for the winning photo in a DailyCaption contest!   #{ link_to 'captioning contest!', caption_url(:id => caption.id) }</fb:fbml>"
    body  "<fb:fbml> #{ caption.caption } </fb:fbml>"
    add_image caption.photo.medium, caption_url(:id => caption.id)
  end
end

