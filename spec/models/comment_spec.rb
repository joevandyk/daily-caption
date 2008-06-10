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

end
