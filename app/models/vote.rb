class Vote < ActiveRecord::Base
  belongs_to :caption, :counter_cache => true
  belongs_to :user
  validates_presence_of :caption
  validates_presence_of :user
  validate :user_can_vote
  named_scope :for_user, lambda { |user| { :conditions => { :user_id => user.id } } }

  def facebook_user
    user.facebook_user
  end

  private

  def user_can_vote
    if ! self.caption.can_vote_for_caption?(self.user)
      errors.add_to_base("Can't vote on this one") and return false
    end
  end
end
