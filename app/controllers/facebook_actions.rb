module FacebookActions
  def update_fb_profile(user) 
    return if user.try(:facebook_user).nil?
    content = render_to_string(:partial=>"/users/fb_profile",:locals=>{:user=>user}) 
    user.push :update_profile, :fbml => content
  end
end
