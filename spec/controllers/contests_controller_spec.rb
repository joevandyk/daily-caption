require File.dirname(__FILE__) + '/../spec_helper'

describe CaptionsController do
  integrate_views
  it "should be ok getting the index" do
    get :index, :user_id => create_user.id
  end
end
