ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes"
  map.resources :fasta_files, :active_scaffold => true, :new => { :extract_sequences =>  :any } 
  map.resources :biodatabases, :active_scaffold => true
  map.resources :blast, :active_scaffold => true
  map.resources :users, :active_scaffold => true
  map.resource :user_session
  map.resource :profile
  map.resource :home

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map the login/logout urls
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"

  map.root :controller => 'profiles', :action => 'show'

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  #  map.connect ':controller/:action/:id'
  #  map.connect ':controller/:action/:id.:format'

end
