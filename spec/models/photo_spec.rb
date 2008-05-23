require File.dirname(__FILE__) + '/../spec_helper'

describe Photo do
  before(:each) do
    @photo = Photo.create! :flickr_id => 12345
  end

  it "should be in the submitted state" do
    @photo.submitted?
  end

  it "should grab the flickr data" do
    @photo.grab_flickr_data!
    @photo.reload
    @photo.ready_for_captioning?.should be_true
  end
end
