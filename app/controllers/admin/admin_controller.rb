class Admin::AdminController < ApplicationController
  before_filter :authenticate
  USERNAME = "jordan"
  PASSWORD = "sucks"

  def index
  end

  private
  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == USERNAME and password == PASSWORD
    end
  end
end
