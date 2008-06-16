class Caption < ActiveRecord::Base
  CAPTION_LIMIT = 3
  CAPTION_LENGTH = 150

  belongs_to :user
  belongs_to :photo
  has_many   :votes
  has_many   :comments

  validates_presence_of :user
  validates_presence_of :photo
  validates_uniqueness_of :caption, :scope => :photo_id, :case_sensitive => false,
    :message => "has already been taken for today's photo."
  validates_length_of :caption, :within => 5..CAPTION_LENGTH,
    :too_short => "must be at least 5 characters long.", 
    :too_long => "can't exceed #{CAPTION_LENGTH} characters."

  before_create :check_for_caption_permission
  after_create  :vote_for_it
  after_create  :send_notification

  named_scope :by_last_added, lambda { |*args| find_captions :created_at,     args }
  named_scope :by_rank,       lambda { |*args| find_captions :votes_count,    args }
  named_scope :by_comments,   lambda { |*args| find_captions :comments_count, args }

  named_scope :recent, :limit => 4, :order => 'created_at desc'

  def voted_for? user
    ! self.votes.for_user(user).empty?
  end

  def can_vote_for_caption? user=nil
    return false unless user
    self.photo.captioning? and !voted_for?(user)
  end

  def facebook_user
    user.facebook_user
  end
  
  # Should return true if caption is marked as SPAM
  def deleted?
    false
  end
  
  def votes_count
    self[:votes_count] or 0
  end

  private

  def self.find_captions sort_by, args
    caption_to_ignore = args.first
    if caption_to_ignore.nil?
      { :order => "#{sort_by} desc" }
    else
      { :order => "#{sort_by} desc", :conditions => ["id != ?", caption_to_ignore.id] }
    end
  end

  def check_for_caption_permission
    unless self.photo.number_of_captions_user_can_add(self.user) > 0
      errors.add_to_base("Can't create more than #{CAPTION_LIMIT} captions per photo") and return false
    end
  end

  def send_notification
    begin
      logger.info "Publishing feed for caption"
      FacebookPublisher.deliver_caption_action self if RAILS_ENV != 'test'
    rescue StandardError
      nil
    end
  end

  def vote_for_it
    self.votes.create! :user => self.user
  end

end
