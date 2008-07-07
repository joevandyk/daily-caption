module FacebookActions
  def update_fb_profile(user) 
    return if user.try(:facebook_user).nil?
    fb_user = user.facebook_user
    content = render_to_string(:partial=>"/users/fb_profile",:locals=>{:user=>user}) 
    queue_up("facebook_profile_update", user, fb_user, content)
  end
end
