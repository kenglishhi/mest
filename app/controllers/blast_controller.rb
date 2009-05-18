class BlastController < ApplicationController
#  include BioUtils

  def index
     @blast_command = BlastCommand.new(:evalue => 0.0001 ) 
     @fasta_file_options =  FastaFile.find(:all, :order => 'label' ).map { |ff| [ff.label, ff.id ] }
     render :action => 'blast_form'
  end
  
  def blast
    @blast_command = BlastCommand.create(params[:blast_command]  )
    if @blast_command.valid?
      @blast_command.save
    else 
      @fasta_file_options =  FastaFile.find(:all,:order => 'label' ).map { |ff| [ff.label, ff.id ] }
      render :action => 'blast_form'
    end
  end

  def run
    logger.error("[kenglish] called run" ) 
    blast_command = BlastCommand.find(params[:id] ) 
    blast_command.run_command

    render :json => {:result_url => url_for(:controller=> 'blast_commands', :action =>'index'),
             :matches =>blast_command.matches, :number_of_fastas =>blast_command.number_of_fastas,:output_file_url => blast_command.output.url}.to_json

  end

end
