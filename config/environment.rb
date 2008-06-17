# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3"

  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  config.load_paths += %W( #{RAILS_ROOT}/vendor/lib )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make ActiveRecord store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run `rake -D time` for a list of tasks for finding time zone names. Uncomment to use default local time.
  config.time_zone = 'UTC'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_daily_caption_session',
    :secret      => 'b00538f64748f0fbccb5c2f6b460b4ad983597764e7749b2ccb9ed46a7c53fa63da9add5db36d1c78bc5f2fcbc940e8627c2f29b06adc27c340a8c2cb9520540'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
end

require 'flickr'
require_dependency 'object'
require_dependency 'date_extensions'
require 'memcache'

ActionController::AbstractRequest.class_eval do
  def request_method_with_facebook_overrides
    @request_method ||= begin
      case 
        when parameters[:_method]
          parameters[:_method].downcase.to_sym
        when parameters[:fb_sig_request_method]
          parameters[:fb_sig_request_method].downcase.to_sym
        else
          request_method_without_facebook_overrides
      end
    end
  end
  alias_method_chain :request_method, :facebook_overrides
end

ExceptionNotifier.exception_recipients = %w( joe@pinkpucker.net jordanisip@yahoo.com )
