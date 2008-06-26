class UsersController < ApplicationController
  before_filter :find_user
  before_filter :ensure_installed, :only => [:friends, :update_profile]

  def show
    @current_tab = :profile
    respond_to do |format|
      format.fbml  { render :action => :show }
      format.html  { redirect_to facebook_page }
    end
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
