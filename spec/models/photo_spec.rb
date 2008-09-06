require File.dirname(__FILE__) + '/../spec_helper'

describe Photo do
  before(:each) do
    @photo = Photo.create! :flickr_id => "2515403644", :small => 'small.jpg', :medium => 'medium.jpg'
  end

  it "should be in the submitted state" do
    @photo.submitted?
  end

  it "should grab the flickr data" do
    @photo.should_receive(:grab_flickr_data)
    @photo.process_flickr_photo
    @photo.ready_for_captioning?.should == true
  end

  it "should have captions" do
    @photo.ready_for_captioning! and @photo.start_captioning!
    @photo.captions.create! :caption => "This one sucks", :user => create_user
  end

  it "once it's scored, should assign the winning id" do
    make_captionable @photo
    @user = create_user
    create_caption :photo => @photo, :user => @user

    @photo.score_and_rotate!

    @photo.winner_id.should == @user.id
  end
  
  it "should not be viewable if it is a future photo" do
    @photo.should_not be_viewable
  end
  
  it "should be viewable if it is currently being captioned" do
    make_captionable @photo
    @photo.should be_viewable
  end
  
  it "should be viewable if it was captioned in the past" do
    make_captioned @photo
    @photo.should be_viewable
  end
end
