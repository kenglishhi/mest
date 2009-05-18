class BlastCommandsController < ApplicationController
 active_scaffold :blast_commands do |config|
    config.list.label = "Blast Commands"
    config.list.columns = [:evalue, :identity, :score, :output_file_name, :output_file_size, :biodatabase     ]
    config.create.multipart = true
    config.actions.exclude :create, :show, :update
#    config.action_links.add "Blast", :parameters => {:controller => 'blast'},
#    :action => 'index', :type => :table, :page => true
  end

end
