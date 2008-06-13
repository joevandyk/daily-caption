class CommentsController < ApplicationController
  before_filter :ensure_installed
  
  def create
    caption = Caption.find params[:caption_id]
    c = Comment.create :caption => caption, :comment => params[:comment][:comment], :user => current_user
    flash[:error] = show_errors_for_object(c) if c.new_record?
    redirect_to caption_url(caption, :anchor => "comments")
  end

end