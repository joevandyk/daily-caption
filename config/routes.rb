ActionController::Routing::Routes.draw do |map|
  map.namespace(:admin) do |admin|
    admin.root :controller => 'admin'
    admin.resources :photos
  end
  map.resources :invitations
  map.resources :sites
  map.resources :captions
  map.resources :users
  map.resources :contests, :collection => { :archive => :get }
  
  map.votes '/votes/:caption_id', :controller => 'votes', :action => 'create', :method => 'post'
  map.comments '/comments', :controller => 'comments', :action => 'create', :method => 'post'

  map.news  '/news',  :controller => 'static', :action => 'news'

  map.index '/',  :controller => 'contests'
end
