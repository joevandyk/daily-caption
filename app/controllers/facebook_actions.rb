module FacebookActions
  def update_fb_profile(user) 
    return if user.try(:facebook_user).nil?
    fb_user = user.facebook_user
    content = render_to_string(:partial=>"/users/fb_profile",:locals=>{:user=>user}) 
    action = render_to_string(:partial=>"/users/fb_profile_action",:locals=>{:user=>user}) 
    queue_up("facebook_profile_update", fb_user, content, action)
  end
end
