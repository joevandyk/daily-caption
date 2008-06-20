ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.global_fixtures = :photos
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
end

def make_captionable photo
  photo.ready_for_captioning!
  photo.start_captioning!
end

def make_captioned photo
  photo.ready_for_captioning!
  photo.start_captioning!
  photo.score_and_rotate!
end

def create_user
  username = Faker::Name.name
  User.create! :site_id => 1, :username => username, :profile_url => "http://facebook.com/#{username}", :profile_image_url => "http://facebook.com/#{username}/profile.png"
end

def create_photo options={}
  default = { :flickr_id => "1234567890" }
  Photo.create! default.update(options)
end

def create_caption options={}
  default = { :user => create_user, :caption => Faker::Lorem.sentence(5) }
  Caption.create default.update(options)
end

def create_comment options={}
  default = { :user => create_user, :caption => create_caption, :comment => Faker::Lorem.sentence(10) }
  Comment.create default.update(options)
end

def login user, pass
  @request.env['HTTP_AUTHORIZATION'] = 'Basic ' + Base64::encode64("#{user}:#{pass}")
end

def login_as_admin
  login Admin::AdminController::USERNAME, Admin::AdminController::PASSWORD
end
