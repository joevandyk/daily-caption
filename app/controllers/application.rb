# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
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

  def facebook_session
    session[:facebook_session]
  end

  def ensure_installed
    ensure_application_is_installed_by_facebook_user
  end
end
