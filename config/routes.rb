ActionController::Routing::Routes.draw do |map|
  map.resources :users
  map.resources :users
  map.resources :votes
  map.resources :votes
  map.resources :sites
  map.resources :users
  map.resources :photos
  map.root :controller => "contest"
end
