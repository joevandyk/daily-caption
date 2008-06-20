
require File.dirname(__FILE__) + '/../spec_helper'

describe FacebookPublisher do
  before(:each) do
    @photo = create_photo
    make_captionable(@photo)
    @caption = create_caption :photo => @photo
    @comment = create_comment :caption => @caption
  end

  it "an action for making a caption should work" do
    action = FacebookPublisher.create_caption_action(@caption)
  end

  it "should be able to send a comment action" do
    action = FacebookPublisher.create_comment_action(@comment)
  end
  
  it "should send feed action for a winning caption" do
    action = FacebookPublisher.create_winning_caption_action(@caption)
  end
  
  it "should send notification for the contest winner" do
    action = FacebookPublisher.create_notify_winner(@caption)
  end
  
  it "should notify caption author of new comment" do
    action = FacebookPublisher.create_notify_caption_comment(@caption, @comment)
  end
  
  it "should e-mail the author of the winning caption" do
    action = FacebookPublisher.create_email_winner(@caption)
  end
  
  it "should send feed action to voters of winning caption" do
    voter = create_user
    action = FacebookPublisher.create_winning_voters_action(@caption, voter)
  end
end
