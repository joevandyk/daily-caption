# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :disable
  before_filter :ensure_current_photo
  include FacebookActions
  include HoptoadNotifier::Catcher
  
  helper :all # include all helpers, all the time
  attr_accessor :current_user
  helper_attr :current_user
  before_filter :set_current_user
  private

  def facebook_page
     "http://apps.facebook.com#{Facebooker.facebook_path_prefix}"
  end

  def set_current_user
    facebook_session || set_facebook_session
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

  def ensure_installed
    ensure_application_is_installed_by_facebook_user
    set_current_user
  end

  def ensure_current_photo
    if !self.kind_of?(Admin::AdminController) and  Photo.current.nil?
      raise "Uh oh, there is no current photo!" 
    end
  end

  def disable
    render :text => "Daily Caption will return shortly!"
    return false
  end
end
