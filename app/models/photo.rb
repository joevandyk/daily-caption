class Photo < ActiveRecord::Base
  validates_presence_of :flickr_id
  has_many :captions

  acts_as_state_machine :initial => :submitted
  state :submitted
  state :ready_for_captioning, :enter => :grab_flickr_data
  state :captioning
  state :captioned
  state :flickr_failure

  event :grab_flickr_data do
    transitions :from => :submitted, :to => :ready_for_captioning
  end

  event :start_captioning do
    transitions :from => :ready_for_captioning, :to => :captioning
  end

  def winning_caption
    self.captions.find :first, :order => 'votes_count desc'
  end


  def self.current
    Photo.find_in_state(:first, :captioning, :order => 'id')
  end

  def find_captions_by_last_added
    winning_caption = self.winning_caption
    captions.find :all, :conditions => "id != #{winning_caption.id}", :order => 'created_at desc'
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
