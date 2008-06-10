class CommentsController < ApplicationController
  before_filter :ensure_installed

  def create
    caption = Caption.find params[:caption_id]
    c = Comment.create! :caption => caption, :comment => params[:comment][:comment], :user => current_user
    raise c.errors.full_messages.inspect if c.new_record?
    redirect_to caption_url(caption)
  end

end
