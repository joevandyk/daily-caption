class CommentsController < ApplicationController
  before_filter :ensure_installed, :except => [:index]
  
  def create
    caption = Caption.find params[:caption_id]
    c = Comment.create :caption => caption, :comment => params[:comment][:comment], :user => current_user
    if c.new_record?
      flash[:error] = show_errors_for_object(c) 
    else
      update_fb_profile(current_user) 
    end
    redirect_to caption_url(caption, :anchor => "comments")
  end
  
  def index
    @user = User.find params[:user_id]
    @comments = @user.comments
  end
end
