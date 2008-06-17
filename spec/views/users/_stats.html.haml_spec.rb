
require File.dirname(__FILE__) + '/../../spec_helper'

describe "/users/_stats.fbml.haml" do
  it "should render the stats profile ok" do
    render :partial => "/users/stats.fbml.haml", :locals => { :user => create_user }
    response.should be_success
  end
end
