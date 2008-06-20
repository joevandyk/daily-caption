class UsersController < ApplicationController
  before_filter :find_user
  ensure_authenticated_to_facebook

  def show
    @current_tab = :profile
  end
  
  def friends
  end
  
  def update_profile
    update_fb_profile(@user)
    redirect_to "http://www.facebook.com/profile.php?id=#{@user.facebook_user.id}"
  end
  
  private
  
  def find_user
    @user = User.find(params[:id])
  end
end
