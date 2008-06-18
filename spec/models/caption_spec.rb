require File.dirname(__FILE__) + '/../spec_helper'

describe Caption do
  before(:each) do
    @user = create_user
    @photo = create_photo
    make_captionable @photo
    @caption = create_caption :user => @user, :photo => @photo
    @caption.should_not be_new_record
  end

  it "should have to have a user" do
    @caption.user = nil
    @caption.save
    @caption.errors.on(:user).should == "can't be blank"
  end

  it "should automatically vote for a caption that you make" do
    @caption.should be_voted_for(@user)
  end

  it "should be able to find captions by the last one added" do
    Caption.by_last_added.should == [@caption]
    Caption.by_last_added(@caption).should be_empty
  end

  it "should be able to find captions by rank" do
    Caption.by_rank.should == [@caption]
    Caption.by_rank(@caption).should be_empty
  end

  it "should be able to find captions by number of comments" do
    Caption.by_comments.should == [@caption]
    Caption.by_comments(@caption).should be_empty
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
    2.times  do
      create_caption :user => @user, :photo => photo
    end

    lambda { create_caption(:photo => photo, :user => @user).save! }.should raise_error(ActiveRecord::RecordNotSaved)
  end

  it "captions can't be more than 150 characters long" do
    bad_caption = "s" * 151
    caption = create_caption :user => @user, :photo => @caption.photo, :caption => bad_caption
    caption.errors.on(:caption).should =~ /can't exceed/
  end
  
  it "captions should be unique within the same photo" do
    caption = create_caption :caption => @caption.caption, :photo => @caption.photo
    caption.errors.on(:caption).should =~ /already been taken for today/
  end
  
  it "should fail" do
    flunk 
  end
end
