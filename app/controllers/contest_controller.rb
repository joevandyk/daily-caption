class AccountController < ApplicationController
  ensure_authenticated_to_facebook

  def index
    @user = session[:facebook_session].user
  end

end