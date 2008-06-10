class Caption < ActiveRecord::Base
  CAPTION_LIMIT = 3
  CAPTION_LENGTH = 150

  belongs_to :user
  belongs_to :photo
  has_many   :votes
  has_many   :comments

  validates_presence_of :user
  validates_presence_of :photo
  validates_length_of :caption, :within => 5..CAPTION_LENGTH

  before_create :check_for_caption_permission
  after_create  :vote_for_it
  after_create  :send_notification

  named_scope :by_last_added, lambda { |winning_caption|
    if winning_caption.nil?
      { :order => 'created_at desc' }
    else
      { :order => 'created_at desc', :conditions => ["id != ?", winning_caption.id] }
    end
  }

  named_scope :by_rank, lambda { |winning_caption|
    if winning_caption.nil?
      { :order => 'votes_count desc' }
    else
      { :order => 'votes_count desc', :conditions => ["id != ?", winning_caption.id] }
    end
  }

  named_scope :by_comments, lambda { |winning_caption|
    if winning_caption.nil?
      { :order => 'comments_count desc' }
    else
      { :order => 'comments_count desc', :conditions => ["id != ?", winning_caption.id] }
    end
  }

  named_scope :recent, :limit => 2, :order => 'created_at desc'

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

  def check_for_caption_permission
    if self.photo.captions.count(:conditions => "user_id = #{self.user_id}") >= CAPTION_LIMIT
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
