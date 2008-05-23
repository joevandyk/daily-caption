class Photo < ActiveRecord::Base
  acts_as_state_machine :initial => 'submitted'
  state :submitted
end
