module FacebookActions
  def update_fb_profile(user) 
    if fb_user = user.facebook_user
      content = render_to_string(:partial=>"/users/fb_profile",:locals=>{:user=>user}) 
      action= render_to_string(:partial=>"/users/fb_profile_action",:locals=>{:user=>user}) 
      fb_user.set_profile_fbml(content,nil,action) 
    end 
  end
end