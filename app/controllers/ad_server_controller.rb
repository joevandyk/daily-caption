class AdServerController < ApplicationController
  include ApplicationHelper
  def ad
    advert = advertisement(params[:ad_slot], params[:width], params[:height])
    render :text => advert
  end
end
