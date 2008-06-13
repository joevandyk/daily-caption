require File.dirname(__FILE__) + '/../spec_helper'

describe Photo do
  before(:each) do
    @photo = Photo.create! :flickr_id => "2515403644"
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
end
