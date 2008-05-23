ActionController::Routing::Routes.draw do |map|
  map.namespace(:admin) do |admin|
    admin.root :controller => 'admin'
    admin.resources :photos
  end
  map.resources :users
  map.resources :votes
  map.resources :sites
  map.root :controller => "contest"
end
