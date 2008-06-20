class UsersController < ApplicationController
  before_filter :find_user
  before_filter :ensure_installed, :only => [:friends, :update_profile]

  def show
    @current_tab = :profile
  end
  
  def friends
    @fb_friends = current_user.facebook_user.friends_with_this_app
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
