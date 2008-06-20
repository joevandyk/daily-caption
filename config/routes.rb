ActionController::Routing::Routes.draw do |map|
  map.namespace(:admin) do |admin|
    admin.root :controller => 'admin'
    admin.resources :photos
    admin.resources :stats
  end
  map.resources :invitations
  map.resources :sites
  map.resources :captions

  map.resources :users, :member => { :friends => :get } do |user|
    user.resources :captions
    user.resources :votes
    user.resources :comments
  end
  
  map.ad_server '/ad_server', :controller => 'ad_server', :action => 'ad'
  map.update_profile '/users/:id/update_profile', :controller => 'users', :action => 'update_profile'
  map.resources :contests, :collection => { :archive => :get }

  map.votes '/votes/:caption_id', :controller => 'votes', :action => 'create', :method => 'post'
  map.comments '/comments', :controller => 'comments', :action => 'create', :method => 'post'

  map.news  '/news',  :controller => 'static', :action => 'news'

  map.index '/',  :controller => 'contests'
end
