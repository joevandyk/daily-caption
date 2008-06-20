
require File.dirname(__FILE__) + '/../spec_helper'

describe FacebookPublisher do
  before(:each) do
    @photo = create_photo
    make_captionable(@photo)
    @caption = create_caption :photo => @photo
  end

  it "an action for making a caption should work" do
    action = FacebookPublisher.create_caption_action(@caption)
    puts action
  end

end
