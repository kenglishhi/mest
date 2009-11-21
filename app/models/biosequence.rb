class Biosequence < ActiveRecord::Base
  include ExtJS::Model
  extjs_fields :id, :name, :alphabet, :length, :seq, :original_name
  cattr_reader :per_page
  @@per_page = 200
  named_scope :first_in_biodatabase, lambda {|biodatabase|
    {:conditions => ['biodatabase_biosequences.biodatabase_id =?', biodatabase.id],
      :include =>'biodatabase_biosequences',
      :limit => 1
    }
  }

  has_many :biodatabase_biosequences, :dependent => :destroy
  has_many :biodatabases, :through => :biodatabase_biosequences

  validates_uniqueness_of :name
  validates_presence_of :name
  validates_presence_of :alphabet
  validates_presence_of :seq

  def to_fasta
    ">#{name}\n#{seq}\n"
  end
  def self.purge_unassigned_sequences
    sql =<<-EOSQL
        SELECT bs.id id, bs.name
        FROM `biosequences` bs
          LEFT OUTER JOIN biodatabase_biosequences bdbs ON (bdbs.biosequence_id = bs.id)
        WHERE bdbs.biodatabase_id IS NULL
        LIMIT 20
EOSQL
    data =  self.connection.select_all(sql)
    begin
      ids = data.map{|rec| rec['id'] }
      deleted = self.delete_all ['id in (?) ', ids]
      data =  self.connection.select_all(sql)
    end while (data.size > 0 )
#    break if data.size == 0
#    puts data.inspect
#    puts ids.inspect



  end
  def to_s
    to_fasta
  end

end