ActionController::Routing::Routes.draw do |map|
  map.namespace(:admin) do |admin|
    admin.root :controller => 'admin'
    admin.resources :photos
    admin.resources :stats
  end
  map.resources :invitations
  map.resources :sites
  map.resources :captions

  map.resources :users do |user|
    user.resources :captions
    user.resources :votes
  end

  map.resources :contests, :collection => { :archive => :get }
  
  map.votes '/votes/:caption_id', :controller => 'votes', :action => 'create', :method => 'post'
  map.comments '/comments', :controller => 'comments', :action => 'create', :method => 'post'

  map.news  '/news',  :controller => 'static', :action => 'news'

  map.index '/',  :controller => 'contests'
end
