require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  it "should find the number of wins for a user" do
    @winner = create_user
    @loser  = create_user
    create_photo :winner_id => @winner.id
    create_photo :winner_id => @winner.id

    @winner.number_of_wins.should == 2
    @loser. number_of_wins.should == 0
  end

  it "should not fail" do
    true.should == true
  end
end
