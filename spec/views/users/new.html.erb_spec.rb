require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/new.html.erb" do
  include UsersHelper

  before(:each) do
    @user = mock_model(User)
    @user.stub!(:new_record?).and_return(true)
    @user.stub!(:site_id).and_return("1")
    @user.stub!(:username).and_return("MyString")
    @user.stub!(:email).and_return("MyString")
    @user.stub!(:profile_url).and_return("MyString")
    @user.stub!(:profile_image_url).and_return("MyString")
    assigns[:user] = @user
  end

  it "should render new form" do
    render "/users/new.html.erb"

    response.should have_tag("form[action=?][method=post]", users_path) do
      with_tag("input#user_username[name=?]", "user[username]")
      with_tag("input#user_email[name=?]", "user[email]")
      with_tag("input#user_profile_url[name=?]", "user[profile_url]")
      with_tag("input#user_profile_image_url[name=?]", "user[profile_image_url]")
    end
  end
end
