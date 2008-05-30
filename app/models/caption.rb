class Caption < ActiveRecord::Base
  belongs_to :user
  belongs_to :photo
  #validates_presence_of :user
  validates_presence_of :caption
  validates_presence_of :photo
end
