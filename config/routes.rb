ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  # Restful Authentication Resources
  map.resources :users
  map.resources :fasta_files

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "fasta_files"

  # See how all your routes lay out with "rake routes"
# config/routes.rb
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"


  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  #  map.connect ':controller/:action/:id'
  #  map.connect ':controller/:action/:id.:format'

end
