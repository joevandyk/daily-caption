require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserFriend do
  before(:each) do
    @user_friends = UserFriend.new
  end

  it "should be valid" do
    @user_friends.should be_valid
  end
end
