require File.dirname(__FILE__) + '/../spec_helper'

describe Photo do
  before(:each) do
    @photo = Photo.create! :flickr_id => "2515403644"
  end

  it "should be in the submitted state" do
    @photo.submitted?
  end

  it "should grab the flickr data" do
    @photo.grab_flickr_data!
    @photo.ready_for_captioning?.should == true
  end
end
