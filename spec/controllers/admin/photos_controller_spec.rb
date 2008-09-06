require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::PhotosController do
  integrate_views
  before(:each) do
    login_as_admin
  end

  it "should create photos based off input" do
    post :create, "photos" => ["123", "456", "789"]
    flash[:notice].should == "3 photos created"
    Photo.count.should == 4
    assert_redirected_to new_admin_photo_path
  end

  it "should delete a photo" do
    photo = create_photo
    assert_difference "Photo.count", -1 do
      post :destroy, :id => photo.id
    end
    lambda { photo.reload }.should raise_error(ActiveRecord::RecordNotFound)
  end
end
