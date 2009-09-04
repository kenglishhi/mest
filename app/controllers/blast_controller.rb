class BlastController < ApplicationController
#  include BioUtils

  def index
     @blast_command = BlastCommand.new(:evalue => 0.0001 ) 
     @blast_command.biodatabase_type_id = BiodatabaseType.find_by_name("GENERATED-MASTER").id
     @fasta_file_options =  FastaFile.find(:all, :order => 'label' ).map { |ff| [ff.label, ff.id ] }
     render :action => 'blast_form'
  end

  def blast
    @blast_command = BlastCommand.new(params[:blast_command]  )
    if @blast_command.valid?
      @blast_command.save
    else
      @fasta_file_options =  FastaFile.find(:all,:order => 'label' ).map { |ff| [ff.label, ff.id ] }
      render :action => 'blast_form'
    end
  end

 	def clean
    @biodatabase = Biodatabase.find(params[:biodatabase_id] )
#    @blast_command = BlastCommand.new(:evalue => 0.0001, :query_fasta_file_id => @biodatabase.fasta_file_id)
#    @blast_command.biodatabase_type_id = BiodatabaseType.find_by_name("UPLOADED-CLEANED").id
    @fasta_file_options =  FastaFile.find(:all, :order => 'label' ).map { |ff| [ff.label, ff.id ] }
    render :action => 'clean_form'
	end

 	def blast_clean

    @blast_command = BlastCommand.new(params[:blast_command]  )
    if @blast_command.valid?
      @blast_command.save
#      @blast_command.run_command(BiodatabaseType.find_by_name("Clearned Stage 1"))
      render :action => 'blast'
    else
      @fasta_file_options =  FastaFile.find(:all,:order => 'label' ).map { |ff| [ff.label, ff.id ] }
      render :action => 'clean_form'
    end

#    @blast_command = BlastCommand.new(:evalue => 0.0001, :query_fasta_file_id => @biodatabase.fasta_file_id)
#    @fasta_file_options =  FastaFile.find(:all, :order => 'label' ).map { |ff| [ff.label, ff.id ] }

	end


  def run
    logger.error("[kenglish] called run" ) 
    blast_command = BlastCommand.find(params[:id] ) 
    blast_command.run

		blast_command.biodatabase.generate_fasta
    render :json => {:result_url => url_for(:controller=> 'blast_commands', :action =>'index'),
             :matches =>blast_command.matches, :number_of_fastas =>blast_command.number_of_fastas,:output_file_url => blast_command.output.url}.to_json

  end

end
