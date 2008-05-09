
require 'rubygems'
gem 'activeresource'
require 'activeresource'

class User < ActiveResource::Base
  self.site = "http://localhost:3002"
end

u = User.create :username => "Bob"
puts User.find(u.id).inspect
puts User.find(:all).inspect
