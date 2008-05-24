require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::AdminController do
  integrate_views


  it "failed logins should fail" do
    get :index
    response.should_not be_success

    login 'bad', 'info'
    get :index
    response.should_not be_success
  end

  it "successful logins should pass" do
    login_as_admin
    get :index
    response.should be_success
  end


end
