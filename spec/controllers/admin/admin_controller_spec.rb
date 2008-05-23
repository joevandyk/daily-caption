require File.dirname(__FILE__) + '/../../spec_helper'

describe Admin::AdminController do
  integrate_views

  def login user, pass
    @request.env['HTTP_AUTHORIZATION'] = 'Basic ' + Base64::encode64("#{user}:#{pass}")
  end

  it "failed logins should fail" do
    get :index
    response.should_not be_success

    login 'bad', 'info'
    get :index
    response.should_not be_success
  end

  it "successful logins should pass" do
    login Admin::AdminController::USERNAME, Admin::AdminController::PASSWORD
    get :index
    response.should be_success
  end


end
