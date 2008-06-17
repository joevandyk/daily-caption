class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :caption, :counter_cache => true
  validates_presence_of :user
  validates_presence_of :caption
  validates_length_of :comment, :minimum => 5
  validates_uniqueness_of :comment, :scope => :caption_id, :case_sensitive => false
  after_create :send_notification
  delegate :facebook_user, :to => :user
  
  named_scope :recent, :limit => 3, :order => 'created_at desc'

  private

  def send_notification
    unless self.user_id == self.caption.user_id
      FacebookPublisher.queue(:deliver_notify_caption_comment, self.caption, self)
    end
  rescue StandardError
    nil
  end
end
