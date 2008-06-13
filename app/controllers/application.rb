# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :ensure_current_photo
  include FacebookActions
  
  helper :all # include all helpers, all the time
  attr_accessor :current_user
  helper_attr :current_user
  before_filter :set_current_user
  private

  def facebook_page
     "http://apps.facebook.com#{Facebooker.facebook_path_prefix}"
  end

  def set_current_user
    if facebook_session
      begin
        self.current_user = User.for(facebook_session.user.to_i, facebook_session)
      rescue Facebooker::Session::MissingOrInvalidParameter => e
        logger.info e
      end
    end
  end

  def show_errors_for_object object
    object.errors.full_messages.to_sentence
  end

  def facebook_session
    if session[:facebook_session] 
      session[:facebook_session]
    elsif params[:fb_sig_user]
      set_facebook_session
    end
  end

  def ensure_installed
    ensure_application_is_installed_by_facebook_user
  end

  def ensure_current_photo
    if Photo.current.nil?
      raise "Uh oh, there is no current photo!" 
    end
  end
end
