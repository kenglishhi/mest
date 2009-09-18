class Blast::CreateDbs < Blast::Base

  protected

  def do_run
    evalue = params[:evalue].blank? ?  0.000001 : params[:evalue]
    test_fasta_file = FastaFile.find(params[:test_fasta_file_id])
    target_fasta_file = FastaFile.find(params[:target_fasta_file_id])
    target_fasta_file.formatdb

    test_fasta_file.extract_sequences if !test_fasta_file.is_generated &&
      test_fasta_file.biodatabase.nil?
    target_fasta_file.extract_sequences if !target_fasta_file.is_generated &&
      target_fasta_file.biodatabase.nil?

    output_biodatabase_group_name = params[:output_biodatabase_group_name] ||
      "#{test_fasta_file.biodatabase.name} vs #{target_fasta_file.biodatabase.name}"
    output_file_handle = Blast::Command.execute(:test_file_path => test_fasta_file.fasta.path,
      :target_file_path => target_fasta_file.fasta.path,
      :evalue => evalue,
      :output_file_prefix => output_biodatabase_group_name.underscore)

    output_file_handle.open
    result_ff = Bio::FlatFile.open(output_file_handle)
    @matches = 0
    @number_of_fastas = 0

    match_biodatabase_type = BiodatabaseType.find_by_name(BiodatabaseType::GENERATED_MATCH)
    BiodatabaseGroup.transaction do
      output_biodatabase_group = BiodatabaseGroup.create(:name => output_biodatabase_group_name,
        :project_id => test_fasta_file.project_id,
        :user_id => params[:user_id])
      result_ff.each do |report|
        test_biosequence = Biosequence.find_by_name(report.query_def)
        #
        first_flag = true
        child_biodatabase =nil
        report.each do |hit|

          if first_flag
            @number_of_fastas += 1
            child_biodatabase = Biodatabase.new(:name => "#{output_biodatabase_group.name } #{@number_of_fastas}",
              :biodatabase_group => output_biodatabase_group,
              :biodatabase_type => match_biodatabase_type,
              :user_id => params[:user_id] )

            child_biodatabase.biosequences << test_biosequence
            first_flag = false
          end
          @matches += 1
          # puts "Hit target = #{hit.target_def}"
          target_biosequence = Biosequence.find_by_name(hit.target_def)

          # puts "hit == #{target_biosequence.nil?}"
          #  puts "hit == #{target_biosequence}"
          child_biodatabase.biosequences << target_biosequence
        end
        child_biodatabase.save! unless child_biodatabase.nil? # no matches
        if child_biodatabase.nil? # no matches
           puts "No Matches"
        end
        return
      end
    end
  end

  #    output_file_handle = Blast::Command.execute(:test_file_path => test_fasta_file.fasta.path,
  #      :target_file_path => target_fasta_file.fasta.path,
  #      :evalue => evalue,
  #      :output_file_prefix => output_biodatabase_group.name.underscore)
  #
  #    test_fasta_file.extract_sequences if !test_fasta_file.is_generated && test_fasta_file.biodatabase.nil?
  #    target_fasta_file.extract_sequences if !target_fasta_file.is_generated && target_fasta_file.biodatabase.nil?
  #    target_fasta_file.formatdb
  #
  #    output_file_handle = execute_blast_command(options)
  #    output_file_handle.open
  #    result_ff = Bio::FlatFile.open(output_file_handle)
  #    @matches = 0
  #    @number_of_fastas = 0
  #
  #    transaction do
  #      output_biodatabase = Biodatabase.new(:name => biodatabase_name,
  #        :biodatabase_type_id =>  biodatabase_type_id,
  #        :parent => test_fasta_file.biodatabase)
  #      output_biodatabase.save
  #
  #      self.biodatabase_id = output_biodatabase.id
  #      save
  #
  #      match_biodatabase_type = BiodatabaseType.find_by_name("GENERATED-MATCH")
  #      result_ff.each do |report|
  #        test_biosequence = Biosequence.find_by_name(report.query_def)
  #
  #        first_flag = true
  #        child_biodatabase =nil
  #        report.each do |hit|
  #          if first_flag
  #            @number_of_fastas += 1
  #            child_biodatabase = Biodatabase.new(:name => "#{output_biodatabase.name } #{@number_of_fastas}",
  #              :biodatabase_type => match_biodatabase_type,
  #              :parent => output_biodatabase)
  #
  #            child_biodatabase.biosequences << test_biosequence
  #            first_flag = false
  #          end
  #          @matches += 1
  #          target_biosequence = Biosequence.find_by_name(hit.target_def)
  #          child_biodatabase.biosequences << target_biosequence
  #        end
  #        child_biodatabase.save unless child_biodatabase.nil? # no matches
  #        return
  #      end
  #      output_biodatabase.save
  #    end
  #    true

end