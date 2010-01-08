class Blast::NrNt < Blast::Base
  DEFAULT_NUMBER_OF_SEQUENCES_TO_SAVE = 10
  protected

  def init_files_and_databases
    @test_biodatabase = Biodatabase.find(Biodatabase.find(@params[:biodatabase_id]) )
    if @test_biodatabase.fasta_file
      @test_biodatabase.fasta_file.overwrite_fasta
    else
      FastaFile.generate_fasta(@test_biodatabase)
    end
    @fasta_file = @test_biodatabase.fasta_file
  end

  def do_run
    init_files_and_databases
    #### blastall -p blastn -i fun.fasta -d /opt/local/var/data/nt
    evalue = get_evalue
    @blast_result = new_blast_result("#{@test_biodatabase.name}-NT Blast Result",@test_biodatabase)
    output_file_handle = Blast::Command.execute_blastall(@blast_result,
      @params.merge({
          :test_file_path => @fasta_file.fasta.path,
          :evalue => evalue,
          :number_of_hits_per_query => number_of_sequences_to_save,
          :nr_nt_flag => true,
          :output_file_prefix => "#{@test_biodatabase.name}-#{@params[:ncbi_database]}"
        })
    )
    output_file_handle.open
    result_ff = Bio::FlatFile.open(output_file_handle)
    process_results(result_ff,@test_biodatabase,@params)

    @blast_result.stopped_at = Time.now
    @blast_result.duration_in_seconds = (@blast_result.stopped_at - @blast_result.started_at)

    @test_biodatabase.fasta_file.overwrite_fasta
    @blast_result.output = output_file_handle
    @blast_result.save!
    @blast_result
  end

  private
  def process_results(bio_result_ff,test_biodatabase,params)
    match_count = 0
    child_biodatabase = nil

    bio_result_ff.each do |report|
      report.each do |hit|

        bioseq = Biosequence.find_by_name( hit.target_def)
        unless bioseq
          begin
            bioseq = Biosequence.new(:name => hit.target_def,
              :seq => hit.target_seq.upcase,
              :alphabet => 'dna',
              :nr_sequence_flag => true,
              :length => hit.target_len,
              :original_name => hit.target_def)
            bioseq.save!
          rescue ActiveRecord::RecordInvalid =>  e
            suffix = "_#{test_biodatabase.id}_#{test_biodatabase.biosequences.size}"
            if ((bioseq.name.size + suffix.size) > 255)
              bioseq.name = bioseq.name[0..(255 - suffix.size - 1)] + suffix
            else
              bioseq.name += suffix
            end
            bioseq.save!
          end
        end
        child_biodatabase ||= create_child_biodatabase(test_biodatabase,params)
        child_biodatabase.biosequences << bioseq unless child_biodatabase.biosequences.include?(bioseq)
        match_count += 1
        break if (match_count >= number_of_sequences_to_save )
      end
      break if (match_count >=number_of_sequences_to_save )
    end
  end
  def create_child_biodatabase(test_biodatabase,params)
    biodatabase_group = find_or_create_ncbi_biodatebase_group(test_biodatabase.parent,params)
    new_db_name = "#{test_biodatabase.name}-#{params[:ncbi_database].upcase}"
    if (child_biodatabase = Biodatabase.find_by_name(new_db_name))
      BiodatabaseBiosequence.delete_all(['biodatabase_id = ? ' , child_biodatabase.id])
    else
      child_biodatabase = Biodatabase.create!(:name => new_db_name,
        :project_id => test_biodatabase.project_id,
        :parent => biodatabase_group ,
        :biodatabase_type => BiodatabaseType.find_by_name(BiodatabaseType::GENERATED_MATCH) ,
        :user_id => params[:user_id])
    end
    if params[:ncbi_database] =='nt'
      test_biodatabase.biosequences.each do | bioseq|
        child_biodatabase.biosequences << bioseq
      end
    end
    child_biodatabase
  end
  def find_or_create_ncbi_biodatebase_group(parent_biodatabase_group,params)
    child_db_group_name = "#{params[:ncbi_database].upcase} Output"

    db = Biodatabase.find(:first,
      :conditions => ['name = ? AND parent_id = ?', child_db_group_name,parent_biodatabase_group.id])

    Biodatabase.find_by_name(child_db_group_name)
    unless db
      db = Biodatabase.create!(:name => child_db_group_name,
        :project_id => parent_biodatabase_group.project_id,
        :parent => parent_biodatabase_group,
        :biodatabase_type => BiodatabaseType.database_group ,
        :user_id => params[:user_id])
    end
    db

  end

  def number_of_sequences_to_save
    @number_of_sequences_to_save  unless @number_of_sequences_to_save.nil?
    @number_of_sequences_to_save = params[:number_of_sequences_to_save].blank? ?
      DEFAULT_NUMBER_OF_SEQUENCES_TO_SAVE : params[:number_of_sequences_to_save].to_i
  end

end
