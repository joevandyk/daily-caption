ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
end

def create_user
  User.create! :site_id => 1, :username => "Joe Van Dyk", :profile_url => "http://facebook.com/joevandyk", :profile_image_url => "http://facebook.com/joevandyk/profile.png"
end

def create_photo
  Photo.create! :flickr_id => "1234567890"
end

def login user, pass
  @request.env['HTTP_AUTHORIZATION'] = 'Basic ' + Base64::encode64("#{user}:#{pass}")
end

def login_as_admin
  login Admin::AdminController::USERNAME, Admin::AdminController::PASSWORD
end
