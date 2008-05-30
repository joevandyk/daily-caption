# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => '0ae5c5c19007ebf5e4f104b0f4e0ef44'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  attr_accessor :current_user
  helper_attr :current_user
  before_filter :set_current_user

  private

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
end
