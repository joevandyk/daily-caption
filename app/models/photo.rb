class Photo < ActiveRecord::Base
  validates_presence_of :flickr_id
  has_many :captions

  acts_as_state_machine :initial => :submitted
  state :submitted                                      
  state :ready_for_captioning,  :enter => :check_photo_size
  state :captioning,            :enter => :mark_caption_start_time, :exit => :score_contest
  state :captioned              
  state :flickr_failure

  event :start_captioning do
    transitions :from => :ready_for_captioning, :to => :captioning
  end

  event :ready_for_captioning do
    transitions :from => :submitted, :to => :ready_for_captioning
  end

  event :score_and_rotate do
    transitions :from => :captioning, :to => :captioned
  end

  event :flickr_failure do
    transitions :from => [:submitted, :ready_for_captioning], :to => :flickr_failure
  end

  # Finds the past photos
  named_scope :past,   :conditions => "state = 'captioned'", :order => 'captioned_at desc'
  named_scope :recent, :limit => 4, :order => 'captioned_at desc'

  # Finds the current photo
  def self.current
    Photo.find_in_state(:first, :captioning)
  end

  # Processes all new photos (grabs flickr data)
  def self.process_new_photos
    Photo.find_in_state(:all, :submitted).each do |photo|
      photo.process_flickr_photo
    end
  end

  # Finds the next upcoming photo
  def self.upcoming_photo
    Photo.find_in_state(:first, :ready_for_captioning, :order => 'id')
  end

  # Given an array of flickr_ids, creates a bunch of photos and submits a bj for 
  # further flickr processing
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

  # Rotate the current photo if it's ready to be rotated
  def self.rotate_if_ready
    if !Photo.current
      Photo.upcoming_photo.start_captioning! and return
    end
    if Photo.current and Photo.current.ready_for_rotation?
      Photo.current.score_and_rotate!
    end
  end

  # Find the winning caption for the photo
  def winning_caption
    self.captions.find :first, :order => 'votes_count desc, created_at asc'
  end

  def next
    Photo.find(:first, :conditions => ['captioned_at > ?', self.captioned_at], :order => "captioned_at")
  end
  
  def previous
    Photo.find(:first, :conditions => ['captioned_at < ?', self.captioned_at], :order => "captioned_at desc")    
  end
  
  def previous_winner
    self.previous.try(:winning_caption).try(:user)
  end

  def number_of_captions_user_can_add user
    Caption::CAPTION_LIMIT - self.captions.count(:conditions => "user_id = #{user.id}") 
  end
  
  def current?
    self == Photo.current
  end
  
  # Checks to see if the photo is ready for rotation
  def ready_for_rotation?
    self.ended_captioning_at <= Time.now
  end
  
  # Checks to see if the photo is still valid from flickr.
  def process_flickr_photo
    grab_flickr_data
    ready_for_captioning!
    save!
  end
    
  def grab_flickr_data
    flickr_photo = Flickr::Photo.new(self.flickr_id)
    flickr_photo.sizes.each do |size|
      self.send "#{size['label'].downcase}=", size['source']
    end
    self.author = flickr_photo.owner.username.to_s.strip
    self.photostream = flickr_photo.url
  rescue RuntimeError
    flickr_failure!
  end
  
  def viewable?
    return true if self.captioning?
    return true if self.captioned?
    return false
  end
  
  private

  def check_photo_size
    raise "No small image!"  unless self.small 
    raise "No medium image!" unless self.medium
    return true
  end

  def mark_caption_start_time
    self.captioned_at = Time.now
    self.ended_captioning_at = 1.day.from_now.at_beginning_of_day
  end

  def score_contest
    winner = self.winning_caption
    return false if !winner
    Photo.upcoming_photo.start_captioning! if Photo.upcoming_photo

    self.update_attribute :winner_id, winner.user_id

    FacebookPublisher.deliver_email_winner(winner)  rescue StandardError
    FacebookPublisher.deliver_notify_winner(winner)  rescue StandardError
    FacebookPublisher.deliver_winning_caption_action(winner) rescue StandardError
    winner.votes.each do |vote|
      FacebookPublisher.deliver_winning_voters(winner, vote.user) rescue StandardError
    end
  end
end
