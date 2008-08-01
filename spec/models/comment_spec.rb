require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Comment do
  before(:each) do
    @user = create_user
    @photo = create_photo
    make_captionable(@photo)
    @caption = create_caption :user => @user, :photo => @photo
  end

  it "users should be able to have comments" do
    c = create_comment :caption => @caption, :user => @user
    @caption.comments.should be_include(c)
    @user.   comments.should be_include(c)
  end

  it "shouldn't send notification if the user who commented on it is the caption's owner" do
    FacebookPublisher.should_receive(:queue).at_most(1)
    create_comment :caption => @caption, :user => @user
  end

  it "should send notification if the user who commented on it isn't the caption's owner" do
    user = create_user
    FacebookPublisher.should_receive(:queue).at_most(2) # TODO add arguments
    create_comment :caption => @caption, :user => user
  end

  it "should fail" do
    true.should == false
  end

end
