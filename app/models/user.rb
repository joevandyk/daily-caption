class User < ActiveRecord::Base
  has_many :captions, :dependent => :destroy
  has_many :votes, :dependent => :destroy
  has_many :comments, :dependent => :destroy

  def self.for(facebook_id,facebook_session=nil)
    returning find_or_create_by_site_user_id(facebook_id) do |user|
      unless facebook_session.nil?
        user.store_session(facebook_session.session_key) 
      end
    end
  end
  
  def avg_received_votes_per_caption
    (votes_received_captions.size / captions.size) rescue 0
  end
  
  def recently_created_captions
    self.captions.recent
  end
  
  def recently_voted_captions
    Vote.not_for_mine(self).recent.map{ |v| v.caption }
  end
  
  def votes_received_captions
    Vote.for_user(self).map{ |v| v.caption }
  end
  
  def votes_given_captions
    Vote.not_for_mine(self).map{ |v| v.caption }
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

end
