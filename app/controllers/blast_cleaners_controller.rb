class BlastCleanersController < ApplicationController
  def new
    @biodatabase = Biodatabase.find(params[:biodatabase_id] )
#    @blast_command = BlastCommand.new(:evalue => 0.0001, :query_fasta_file_id => @biodatabase.fasta_file_id)
#    @blast_command.biodatabase_type_id = BiodatabaseType.find_by_name("UPLOADED-CLEANED").id
    @fasta_file_options =  FastaFile.find(:all, :order => 'label' ).map { |ff| [ff.label, ff.id ] }
  end
end
