class AlignmentsController < ApplicationController
  before_filter :clear_stored_location, :only => [:index]
  active_scaffold :alignments do |config|
    config.list.label = "Alignments"
    config.list.columns = [:label, :biodatabase, :aln_file_name]
    config.list.sorting = [{:label => :asc}]
#    config.action_links.add "Blast", :parameters => {:controller => 'blast'},
#    :action => 'index', :type => :table, :page => true
  end

end
