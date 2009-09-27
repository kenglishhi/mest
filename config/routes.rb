ActionController::Routing::Routes.draw do |map|

#  map.resources :workbench

  map.resources :biodatabase_links, :active_scaffold => true
  map.resources :biodatabase_link_types, :active_scaffold => true

  map.resources :biodatabase_groups, :active_scaffold => true
  map.resources :biodatabase_types, :active_scaffold => true
  map.resources :projects, :active_scaffold => true
  map.resources :blast_results, :active_scaffold => true
  map.resources :blasts
  map.resources :fasta_files, :active_scaffold => true, :new => { :extract_sequences =>  :any } 
  map.resources :biodatabases, :active_scaffold => true

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes"

#  map.resources :blast, :active_scaffold => true
#  map.resources :adminusers, :controller => "admin/users", :active_scaffold => true
  map.resource :user_session
  map.resources :users

  map.resource :home
  map.namespace(:admin) do |admin|
    admin.resources :users
  end
  map.namespace(:tools) do |tools|
    tools.resources :blast_cleaners
    tools.resources :blast_create_dbs
  end
  map.namespace(:jobs) do |jobs|
    jobs.resources :queued_jobs, :active_scaffold => true
    jobs.resources :running_jobs, :active_scaffold => true
    jobs.resources :failed_jobs, :active_scaffold => true
    jobs.resources :job_logs, :collection => {:delete_all => :post}, :active_scaffold => true
  end

  map.namespace(:workbench) do |admin|
    admin.resources :home
    admin.resources :biodatabases, :member => { :move => :post }
    admin.resources :biodatabase_groups, :member => { :move => :post }
  end

	map.connect 'workbench',
		:controller => 'workbench/home',
		:action     => 'index'


  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map the login/logout urls
  map.login "login", :controller => "user_sessions", :action => "new"
  map.logout "logout", :controller => "user_sessions", :action => "destroy"

  map.root :controller => 'users', :action => 'index'

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
#    map.connect ':controller/:action/:id'
  #  map.connect ':controller/:action/:id.:format'

end
