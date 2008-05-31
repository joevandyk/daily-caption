class Photo < ActiveRecord::Base
  validates_presence_of :flickr_id
  has_many :captions, :order => 'created_at desc'

  acts_as_state_machine :initial => :submitted
  state :submitted
  state :ready_for_captioning, :enter => :grab_flickr_data
  state :captioning
  state :captioned
  state :flickr_failure

  event :grab_flickr_data do
    transitions :from => :submitted, :to => :ready_for_captioning
  end


  def self.current
    Photo.find_in_state(:first, :ready_for_captioning, :order => 'id')
  end

  def self.process_new_photos
    Photo.find_in_state(:all, :submitted).each do |photo|
      photo.grab_flickr_data!
    end
  end

  def self.create_in_bulk flickr_ids
    count = 0
    flickr_ids.each do |flickr_id|
      if ! flickr_id.empty?
        count += 1
        Photo.create! :flickr_id => flickr_id
      end
    end
    Bj.submit "./script/runner Photo.process_new_photos"
    count
  end

  private

  # Checks to see if the photo is still valid from flickr.
  def grab_flickr_data
    flickr_photo = Flickr::Photo.new(self.flickr_id)
    flickr_photo.sizes.each do |size|
      self.send "#{size['label'].downcase}=", size['source']
    end
    self.author = flickr_photo.owner.username.to_s.strip
    self.photostream = flickr_photo.url
    save!
  end

end
