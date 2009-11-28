class Workbench::AlignmentsController < ApplicationController
  include ExtJS::Controller
  protect_from_forgery :except => :destroy

  def index
    data = FastaFile.with_alignments

    render :json => {:results => data.count, :data => data.map{|row|row.to_record}}
  end
end
