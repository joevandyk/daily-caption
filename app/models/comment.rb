class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :caption
  validates_presence_of :user
  validates_presence_of :caption
  validates_length_of :comment, :minimum => 5
end
