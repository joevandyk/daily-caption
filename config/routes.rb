ActionController::Routing::Routes.draw do |map|
  map.namespace(:admin) do |admin|
    admin.root :controller => 'admin'
    admin.resources :photos
  end
  map.resources :invitations
  map.with_options :controller => 'invitations' do |m|
    m.invitations 'dailycaptionjoe/invitations/', :action => 'index'
  end
  map.resources :sites
  map.resources :captions
  map.resources :users
  map.resources :contests

  map.votes '/votes/:caption_id', :controller => 'votes', :action => 'create', :method => 'post'

  map.index '/',  :controller => 'contests'
  
  # Install the default route as the lowest priority.
  map.connect '/:controller/:action/:id'
end
