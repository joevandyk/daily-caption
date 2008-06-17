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
  
  def number_of_wins
    Photo.count :conditions => "winner_id = #{self.id}"
  end

  def avg_received_votes_per_caption
    self.captions.average(:votes_count)
  end
  
  def recently_created_captions
    self.captions.recent
  end
  
  def recently_created_comments
    self.comments.recent
  end
  
  def recently_voted_captions
    Vote.not_for_mine(self).recent.map{ |v| v.caption }
  end
  
  def votes_received_captions
    Vote.for_user(self).map{ |v| v.caption }
  end
  
  def most_recent_caption
    Caption.find(:first, :conditions => ["user_id = ?", self.id], :order => "created_at desc")
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
