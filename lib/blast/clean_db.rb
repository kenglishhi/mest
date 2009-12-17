class Blast::CleanDb < Blast::Base

  protected

  def init_files_and_databases
    @test_database = Biodatabase.find(@params[:biodatabase_id] )
    @test_fasta_file = @test_database.fasta_file
    @test_fasta_file.overwrite_fasta
    raise "Target Fasta File does not exist" unless @test_fasta_file

    @target_fasta_file = @test_fasta_file
    #    if @test_fasta_file.biodatabase.biodatabase_links.any? {|b| b.biodatabase_link_type == BiodatabaseLinkType.cleaned}
    #      raise "There already exists a cleaned database for #{ @test_fasta_file.biodatabase.name}"
    #    end
    @target_fasta_file.formatdb

  end

  def do_run
    init_files_and_databases

    @output_biodatabase = create_clean_output_database(@test_fasta_file.biodatabase)

    blast_result_name = params[:blast_result_name].blank? ?
      params[:blast_result_name] : "#{@output_biodatabase.name} Blast Result"
    @blast_result = new_blast_result(blast_result_name)
    evalue = @params[:evalue] || "25"
    output_file_handle = Blast::Command.execute(:blastall, @blast_result, :test_file_path => @test_fasta_file.fasta.path,
      :target_file_path => @target_fasta_file.fasta.path,
      :evalue => evalue,
      :output_file_prefix => @output_biodatabase.name)
    output_file_handle.open

    @blast_result.stopped_at = Time.now
    @blast_result.duration_in_seconds = (@blast_result.stopped_at - @blast_result.started_at)

    result_ff = Bio::FlatFile.open(output_file_handle)
    @matches = @test_fasta_file.biodatabase.biosequences.size

    # Copy the sequences to the output_biodatabase
    copy_database(@test_fasta_file.biodatabase, @output_biodatabase )

    # Remove any hits
    biosequence_ids_to_delete = []
    threshold = 25 # every 25, we will purge

    result_ff.each do |report|
      test_biosequence = Biosequence.find_by_name(report.query_def)
      if @output_biodatabase.biosequences.include? test_biosequence
        report.each do |hit|
          unless hit.target_def == report.query_def
            target_biosequence = Biosequence.find_by_name(hit.target_def)
            @matches = @matches - 1
            @output_biodatabase.biosequences.delete( target_biosequence )
            # BiodatabaseBiosequence.delete_all(['biodatabase_id =?  AND  biosequence_id =?',
            #    @output_biodatabase.id,
            #    target_biosequence.id])
          end
        end
      end
    end
    @output_biodatabase.save
    FastaFile.generate_fasta(@output_biodatabase)
    BiodatabaseLink.create(:biodatabase =>@test_fasta_file.biodatabase,
      :linked_biodatabase => @output_biodatabase,
      :biodatabase_link_type => BiodatabaseLinkType.cleaned)
    @blast_result.output= output_file_handle
    @blast_result.save!
    @blast_result
  end

  private

  def create_clean_output_database(source_db)
    default_new_biodatabase_name =  "#{source_db.name}-Cleaned"
    new_name = @params[:new_biodatabase_name] ||  default_new_biodatabase_name
    Biodatabase.new(:biodatabase_type =>
        BiodatabaseType.find_by_name(BiodatabaseType::UPLOADED_CLEANED),
      :name => new_name,
      :project_id => source_db.project_id,
      :parent => source_db.parent)
  end

  def copy_database(source_db, dest_db)
    source_db.biosequences.each do | row |
      dest_db.biosequences << row
    end
    dest_db.save
  end

end
