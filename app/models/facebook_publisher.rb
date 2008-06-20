
class FacebookPublisher < Facebooker::Rails::Publisher
  include ApplicationHelper

  def self.queue action, args
    STARLING.set "facebook_actions", [action, *args]
  end
  
  ################################################
    # Facebook Rules for Feed Actions
    # title
      # Up to 60 characters
      # <a> is allowed and there can be zero or one instance
      # <fb:name> is allowed and can have many instances
      # No other tags allowed
    # body
      # Up to 200 characters
      # Can include <fb:name>, <b>, and <i>
      # Up to 4 images
  ###############################################

  def caption_action caption
    url = caption_url(:id => caption.id)
    send_as :action
    from caption.facebook_user
    title "<fb:fbml> #{ name_only(caption.user, :linked => true) } wrote a #{ link_to 'caption', url }</fb:fbml>"
    body  "<fb:fbml> \"#{ link_to caption.caption, url }\" - Help #{ first_name_linked(caption.user) } by voting up this caption on the #{link_to "Daily Caption contest", index_url}! Think you can do better? #{ link_to "Write your own caption!", new_caption_url } </fb:fbml>"
    add_image caption.photo.medium, url
  end

  def comment_action comment
    caption = comment.caption
    url = caption_url(:id => caption.id, :anchor => dom_id(comment))
    send_as :action
    from comment.facebook_user
    title "<fb:fbml> #{name_only comment.user, :linked => true } wrote a #{ link_to 'comment', url } on a caption</fb:fbml>"
    body  "<fb:fbml> \"#{ link_to comment.comment, url }\" - on the caption \"#{ comment.caption.caption }\".</fb:fbml>"
    add_image caption.photo.medium, url
  end

  def winning_caption_action caption
    send_as :action
    from caption.facebook_user
    url = contest_url(:id => caption.photo.id)
    title "<fb:fbml> #{ name_only(caption.user, :linked => true) } won a #{ link_to 'DailyCaption contest', url }!</fb:fbml>"
    body  "<fb:fbml> \"#{ caption.caption }\" won the Daily Caption contest with #{ caption.votes_count } votes! Try to beat #{ first_name_linked(caption.user) } on the #{ link_to "next contest", index_url }!  </fb:fbml>"
    add_image caption.photo.medium, url
  end

  def notify_winner caption
    send_as :notification
    recipients caption.facebook_user
    from caption.facebook_user
    fbml  "<fb:fbml> Good work #{ first_name_linked(caption.user) }! You won a Daily Caption contest with your caption: #{ caption.caption }. Check out the #{ link_to "next contest", index_url }! </fb:fbml>"
  end

  def notify_caption_comment caption, comment
    send_as       :notification
    recipients    caption.facebook_user
    from          comment.facebook_user
    fbml          "<fb:fbml> #{ name_only(comment.facebook_user, :linked => true) } commented on your caption: #{ link_to caption.caption, caption_url(:id => caption.id) }! </fb:fbml>"
  end

  def email_winner caption
    send_as :email
    recipients caption.facebook_user
    from caption.facebook_user
    title "Congratulations on winning a Daily Caption contest!"
    fbml  "<fb:fbml> Good work #{ first_name_linked(caption.user) }! You won a Daily Caption contest with your caption: <p>#{ caption.caption }</p> Head on over to the #{ link_to "next contest", index_url }! </fb:fbml>"
  end

  def winning_voters_action caption, user
    send_as :action
    from user
    url = contest_url(:id => caption.photo.id)
    title "<fb:fbml> #{ name_only(user, :linked => true)} voted for a #{ link_to 'winning_photo!', url }</fb:fbml>"
    body  "<fb:fbml> #{ name_only(caption.user, :linked => true) } wrote the winning caption \"#{ caption.caption }\".  Think you can do better? #{ link_to "Write your own caption!", new_caption_url } </fb:fbml>"
    add_image caption.photo.medium, url
  end
end

