require File.dirname(__FILE__) + '/../spec_helper'

describe Caption do
  before(:each) do
    @user = create_user
    @caption = Caption.new :user => @user, :caption => "My caption rules!", :photo => create_photo
    @caption.save!
  end

  it "should have to have a user" do
    @caption.user = nil
    @caption.save
    @caption.errors.on(:user).should == "can't be blank"
  end

  it "should have to have a caption" do
    @caption.caption = ""
    @caption.save
    @caption.errors.on(:caption).should == "can't be blank"
  end

  it "should have to have a photo" do
    @caption.photo = nil
    @caption.save
    @caption.errors.on(:photo).should == "can't be blank"
  end

end
