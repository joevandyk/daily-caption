class Photo < ActiveRecord::Base
  validates_presence_of :flickr_id

  acts_as_state_machine :initial => :submitted
  state :submitted
  state :ready_for_captioning, :enter => :grab_flickr_data
  state :captioning
  state :captioned
  state :flickr_failure

  event :grab_flickr_data do
    transitions :from => :submitted, :to => :ready_for_captioning
  end
  
  # Checks to see if the photo is still valid from flickr.
  def check_for_flickr_validity
  end

  private

  def grab_flickr_data
  end
end
