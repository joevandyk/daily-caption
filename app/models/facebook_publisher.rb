
class FacebookPublisher < Facebooker::Rails::Publisher
  include ApplicationHelper

  def self.queue action, args
    STARLING.set "facebook_actions", [action, *args]
  end

  def caption_action caption
    url = caption_url(:id => caption.id)
    send_as :action
    from caption.facebook_user
    title "<fb:fbml> #{ name_only(caption.user)} captioned a #{ link_to 'photo', url }</fb:fbml>"
    body  "<fb:fbml> #{ link_to caption.caption, url } - Help vote up this caption on #{link_to "DailyCaption", index_url}!</fb:fbml>"
    add_image caption.photo.medium, url
  end

  def comment_action comment
    caption = comment.caption
    url = caption_url(:id => caption.id)
    send_as :action
    from comment.facebook_user
    title "<fb:fbml> #{name_only comment.user } commented on a #{ link_to 'caption', url }</fb:fbml>"
    body  "<fb:fbml> \"#{ link_to comment.comment, url }\" - Help vote up this caption on #{link_to "DailyCaption", index_url}!</fb:fbml>"
    add_image caption.photo.medium, url
  end

  def winning_caption_action caption
    send_as :action
    from caption.facebook_user
    url = caption_url(:id => caption.id)
    title "<fb:fbml> #{ name_only(caption.user)} won a #{ link_to 'DailyCaption contest!', url }</fb:fbml>"
    body  "<fb:fbml> Winning caption: #{ caption.caption } </fb:fbml>"
    add_image caption.photo.medium, url
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
    url = caption_url(:id => caption.id)
    title "<fb:fbml> #{ name_only(user)} voted for the winning photo in a DailyCaption contest!   #{ link_to 'captioning contest!', url }</fb:fbml>"
    body  "<fb:fbml> #{ caption.caption } </fb:fbml>"
    add_image caption.photo.medium, url
  end
end

