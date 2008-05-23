require File.dirname(__FILE__) + '/../spec_helper'

describe Photo do
  before(:each) do
    @photo = Photo.new
  end

  it "should be valid" do
    @photo.should be_valid
  end
end
