class Blast::Remote < Blast::Base

  protected

  def init_file
    @test_database = Biodatabase.find(@params[:test_biodatabase_id] )
    seq = Biosequence.first_in_biodatabase(@test_database).first
    f = File.open("#{seq.name}.fasta", 'w') {|f| f.write(seq.to_fasta) }
    puts f.inspect
#    @test_fasta_file = @test_database.fasta_file
#    raise "Target Fasta File does not exist" unless @test_fasta_file
#    @target_fasta_file = @test_fasta_file
#    @target_fasta_file.formatdb
  end

  def do_run
    init_file

#    @output_biodatabase = create_clean_output_database(@test_fasta_file.biodatabase)
    return
    blast_result_name = params[:blast_result_name].blank? ?
      params[:blast_result_name] : "#{@output_biodatabase.name} Blast Result"
    @blast_result = BlastResult.new(:name => blast_result_name,
      :started_at => Time.now
    )
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
    result_ff.each do |report|
      test_biosequence = Biosequence.find_by_name(report.query_def)
      if @output_biodatabase.biosequences.include? test_biosequence
        report.each do |hit|
          unless hit.target_def == report.query_def
            target_biosequence = Biosequence.find_by_name(hit.target_def)
            @matches = @matches - 1
            @output_biodatabase.biosequences.delete( target_biosequence )
          end
        end
      end
    end
    @output_biodatabase.save
    FastaFile.generate_fasta( @output_biodatabase)

    BiodatabaseLink.create(:biodatabase =>@test_fasta_file.biodatabase,
      :linked_biodatabase => @output_biodatabase,
      :biodatabase_link_type => BiodatabaseLinkType.cleaned)
    @blast_result.output= output_file_handle
    @blast_result.save!
    @blast_result
  end

  private

  def create_clean_output_database(parent_db)
    default_new_biodatabase_name =  "#{parent_db.name}-Cleaned"
    new_name = @params[:new_biodatabase_name] ||  default_new_biodatabase_name
    Biodatabase.new(:biodatabase_type =>
        BiodatabaseType.find_by_name(BiodatabaseType::UPLOADED_CLEANED),
      :name => new_name,
      :user_id => parent_db.user_id,
      :biodatabase_group => parent_db.biodatabase_group)
  end

  def copy_database(source_db, dest_db)
    source_db.biosequences.each do | row |
      dest_db.biosequences << row
    end
    dest_db.save
  end

end
