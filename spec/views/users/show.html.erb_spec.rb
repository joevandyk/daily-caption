require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/show.html.erb" do
  include UsersHelper

  before(:each) do
    @user = mock_model(User)
    @user.stub!(:site_id).and_return("1")
    @user.stub!(:username).and_return("MyString")
    @user.stub!(:email).and_return("MyString")
    @user.stub!(:profile_url).and_return("MyString")
    @user.stub!(:profile_image_url).and_return("MyString")

    assigns[:user] = @user
  end

  it "should render attributes in <p>" do
    render "/users/show.html.erb"
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
    response.should have_text(/MyString/)
  end
end
