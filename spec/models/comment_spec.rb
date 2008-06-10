require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Comment do
  before(:each) do
    @user = create_user
    @photo = create_photo
    make_captionable(@photo)
    @caption = @photo.captions.create! :user => @user, :photo => @photo, :caption => "Hey dude"
  end

  it "users should be able to have comments" do
    c = Comment.create! :caption => @caption, :user => @user, :comment => "my comment"
    @caption.comments.should be_include(c)
    @user.   comments.should be_include(c)
  end

  it "shouldn't send notification if the user who commented on it is the caption's owner" do
    FacebookPublisher.should_not_receive(:notify_caption_comment)
    c = Comment.create! :caption => @caption, :user => @user, :comment => "my comment"
  end

  it "should send notification if the user who commented on it isn't the caption's owner" do
    FacebookPublisher.should_receive(:deliver_notify_caption_comment)
    c = Comment.create! :caption => @caption, :user => create_user, :comment => "my comment"
  end

end
