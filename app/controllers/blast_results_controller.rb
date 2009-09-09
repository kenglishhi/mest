class BlastResultsController < ApplicationController
  before_filter :clear_stored_location, :only => [:index]
  active_scaffold :blast_results do |config|
    config.list.label = "Blast Results"
    config.list.columns = [:name, :output_file_name, :output_file_size]
#    config.action_links.add "Blast", :parameters => {:controller => 'blast'},
#    :action => 'index', :type => :table, :page => true
  end

end
