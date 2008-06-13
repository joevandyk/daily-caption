require File.dirname(__FILE__) + '/../spec_helper'

describe Caption do
  before(:each) do
    @user = create_user
    @photo = create_photo
    make_captionable @photo
    @caption = Caption.new :user => @user, :caption => "My caption rules!", :photo => @photo
    @caption.save!
  end

  it "should have to have a user" do
    @caption.user = nil
    @caption.save
    @caption.errors.on(:user).should == "can't be blank"
  end

  it "should automatically vote for a caption that you make" do
    @caption.should be_voted_for(@user)
  end

  it "should have to have a caption" do
    @caption.caption = ""
    @caption.save
    @caption.errors.on(:caption).should =~ /at least/
  end

  it "should have to have a photo" do
    @caption.photo = nil
    @caption.save
    @caption.errors.on(:photo).should == "can't be blank"
  end

  it "users can create three captions per photo" do
    photo = @caption.photo
    counter = 0
    2.times  do
      Caption.create! :user => @user, :caption => "another caption #{counter += 1}", :photo => photo
    end

    lambda { Caption.create!(:user => @user, :caption => 'failing caption', :photo => photo)}.should raise_error(ActiveRecord::RecordNotSaved)
  end

  it "captions can't be more than 150 characters long" do
    bad_caption = "s" * 151
    caption = Caption.create :user => @user, :caption => bad_caption, :photo => @caption.photo
    caption.errors.on(:caption).should =~ /can't exceed/
  end
  
  it "captions should be unique within the same photo" do
    @user_2 = create_user
    @caption_2 = Caption.create :user => @user_2, :caption => "My caption rules!", :photo => @photo
    @caption_2.errors.on(:caption).should =~ /already been taken for today/
  end
end
