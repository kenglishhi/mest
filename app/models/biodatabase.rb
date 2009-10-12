class Biodatabase < ActiveRecord::Base
  include ExtJS::Model
  extjs_fields :name,:created_at

  belongs_to :biodatabase_type
  belongs_to :biodatabase_group
  belongs_to :fasta_file
  belongs_to :user

  has_many :biodatabase_biosequences
  has_many :biosequences, :through => :biodatabase_biosequences, :order => 'name'
  has_many :biodatabase_links, :dependent => :destroy
  has_many :linked_biodatabase_links, :class_name =>'BiodatabaseLink', :foreign_key =>'linked_biodatabase_id', :dependent => :destroy

  validates_presence_of :name
  validates_presence_of :biodatabase_type_id
  validates_presence_of :biodatabase_group_id

  validates_uniqueness_of :name
  before_destroy :clear_references

  def clear_references
    biosequence_ids = select_unique_biosequence_ids.map { | row| row.first}
    Biosequence.delete_all(["id in (?) " ,biosequence_ids]) unless biosequence_ids.empty?
    BiodatabaseBiosequence.delete_all(["biodatabase_id = ? " ,self.id])
    fasta_file.destroy if fasta_file.is_generated?
  end

  def select_unique_biosequence_ids
    sql = <<-EOSQL
    SELECT bsdb2.biosequence_id FROM biodatabase_biosequences bsdb1,
( SELECT biosequence_id FROM biodatabase_biosequences  WHERE biodatabase_id= #{id} ) bsdb2
WHERE bsdb1.biosequence_id = bsdb2.biosequence_id
GROUP BY bsdb2.biosequence_id
HAVING COUNT(*) = 1
    EOSQL
    self.connection.select_rows sql
  end

	def number_of_sequences
    self.biosequences.count
	end

  def rename_sequences(prefix)
    padding = Math.log10(self.biosequences.size).to_i + 1
    self.biosequences.each_index do |i|
      new_name = "#{prefix}#{"%0#{padding}d" %   (i+1)  }"
      logger.error("new name = #{new_name}")
      biosequences[i].name = new_name
      biosequences[i].save!

    end
  end

  def generate_fasta
    if fasta_file_id.nil?
      filename =  "#{name}.fasta"
      fasta_file_handle = File.new(filename,"w")
      biosequences.each do | seq |
        fasta_file_handle.puts(seq.to_fasta)
      end
      fasta_file_handle.close
      puts "generating fasta"

      fasta_file_handle = File.new(filename,"r")
      self.fasta_file = FastaFile.new
      self.fasta_file.fasta = fasta_file_handle
      self.fasta_file.project_id = biodatabase_group.project_id
      self.fasta_file.user_id = self.user_id
      self.fasta_file.is_generated = true
      self.fasta_file.save!
      puts "new id #{self.fasta_file.errors.full_messages.to_sentence} "
      save
    end
  end

  private
end
