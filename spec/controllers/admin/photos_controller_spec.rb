require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::PhotosController do
  before(:each) do
    login_as_admin
  end

  it "should create photos based off input" do
    post :create, "photos" => ["123", "456", "789"]
    flash[:notice].should == "3 photos created"
    Photo.count.should == 3
    assert_redirected_to new_admin_photo_path
  end
end
