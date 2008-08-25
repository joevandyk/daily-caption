class User < ActiveRecord::Base
  has_many :captions, :dependent => :destroy
  has_many :votes, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :winning_photos, :class_name => 'Photo', :foreign_key => :winner_id
  has_one  :user_friend

  def self.for(facebook_id,facebook_session=nil)
    returning find_or_create_by_site_user_id(facebook_id) do |user|
      unless facebook_session.nil?
        user.store_session(facebook_session.session_key) 
      end
    end
  end
  
  def number_of_wins
    self.winning_photos.count
  end

  # Subtract one from the votes count, cuz we don't wanna count the automatically generated vote (right?)
  def average_number_of_votes_received_per_caption
    self.captions.average('votes_count - 1') || 0
  end
  
  def recently_created_captions
    self.captions.recent
  end

  def number_of_captions
    self.captions.count
  end
  
  def recently_created_comments
    self.comments.recent
  end
  
  def recently_voted_captions
    Vote.not_for_mine(self).recent.map{ |v| v.caption }
  end
  
  # Subtract the automatically generated votes 
  def number_of_votes_received
    self.captions.sum('votes_count - 1')
  end
  
  def most_recent_caption
    self.captions.find :first, :order => 'created_at desc'
  end
  
  def votes_given_captions
    Vote.not_for_mine(self).map{ |v| v.caption }
  end

  # Async method
  def update_profile fbml
    # TODO should also update friends list
    self.facebook_user.profile_fbml = fbml
  end

  # Number of times voted == Total number of votes - Total number of captions
  def number_of_votes_given
    self.votes.count - self.captions.count
  end
  
  def store_session(session_key)
    if self.session_key != session_key
      update_attribute(:session_key,session_key) 
    end
  end

  def facebook_session
    @facebook_session ||=  
      returning Facebooker::Session.create do |session| 
        session.secure_with!(session_key,site_user_id,1.day.from_now) 
      end
  end

  def facebook_user
    facebook_session.user
  end

  def update_friends!
    self.create_user_friend if self.user_friend.blank?
    self.user_friend.update_attribute :friend_ids, Marshal.dump(self.facebook_user.friends_with_this_app.map{ |f| f.id })
  end
  
  def friends
    return [] if user_friend.try(:friend_ids).blank?
    friend_ids = Marshal.load(self.user_friend.friend_ids)
    User.find :all, :conditions => { :site_user_id => friend_ids }
  end
end
