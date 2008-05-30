ActionController::Routing::Routes.draw do |map|
  map.namespace(:admin) do |admin|
    admin.root :controller => 'admin'
    admin.resources :photos
  end
  
  map.resources :invitations
  map.with_options :controller => 'invitations' do |m|
    m.invitations '/dailycaption/invitations/', :action => 'index'
  end
  map.resources :sites
  map.resources :captions
  map.resources :users
  map.resources :votes
  map.resources :contests

  map.index '/',  :controller => 'contests'
  
  # Install the default route as the lowest priority.
  map.connect '/:controller/:action/:id'
end
