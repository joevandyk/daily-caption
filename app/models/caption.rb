class Caption < ActiveRecord::Base
  CAPTION_LIMIT = 3
  CAPTION_LENGTH = 150

  belongs_to :user
  belongs_to :photo

  validates_presence_of :user
  validates_presence_of :caption
  validates_presence_of :photo
  validates_length_of :caption, :maximum => CAPTION_LENGTH

  before_create :check_for_caption_permission
  after_create  :send_notification

  private

  def check_for_caption_permission
    if self.photo.captions.count(:conditions => "user_id = #{self.user_id}") >= CAPTION_LIMIT
      errors.add_to_base("Can't create more than #{CAPTION_LIMIT} captions per photo") and return false
    end
  end

  def send_notification
    begin
    logger.info "Publishing feed for caption"
    CaptionPublisher.deliver_caption_feed self if RAILS_ENV != 'test'
  rescue StandardError
    nil
  end
  end

end
