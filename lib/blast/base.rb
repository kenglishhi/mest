class Blast::Base

  attr_accessor :test_fasta_file
  attr_accessor :target_fasta_files
  attr_accessor :target_fasta_file
  attr_accessor :output_biodatabase
  attr_accessor :blast_result

  attr_accessor :biodatabase
  attr_accessor :biodatabase_type
  attr_accessor :biodatabase_name

  attr_accessor :matches
  attr_accessor :number_of_fastas
  attr_accessor :params

  def initialize(p={})
    @params = p
    @params.delete_if {|key, value| value.blank? }
  end
  def logger
    Delayed::Worker.logger
  end
  def run
    do_run
  end

  protected

  def get_evalue
    params[:evalue].blank? ?  25 :  params[:evalue]
  end
  def do_run
    raise "subclasses must implement"
  end
  def new_blast_result(blast_result_name)
    @blast_result = BlastResult.create!(:name => blast_result_name,
      :started_at => Time.now,
      :user_id => params[:user_id],
      :project_id => params[:project_id])
  end

end
