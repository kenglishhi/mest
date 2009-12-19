class Workbench::AlignmentsController < ApplicationController
  include ExtJS::Controller
  protect_from_forgery :except => :destroy

  def index
    data = FastaFile.with_alignments
    render :json => {:results => data.count, :data => data.map{|row|row.to_record}}
  end

  def show
    if params[:biodatabase_id]
      fasta_file = Biodatabase.find(params[:biodatabase_id]).fasta_file
    elsif params[:id]
      fasta_file = FastaFile.find(params[:id])
    end
    render :json => fasta_file.alignment_to_hash.to_json
  end

end
