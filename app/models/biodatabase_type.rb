class BiodatabaseType < ActiveRecord::Base

  DATABASE_GROUP = 'Database Group'
  UPLOADED_RAW = 'Uploaded Raw Data'
  UPLOADED_CLEANED = 'Uploaded Cleaned Database'
  GENERATED_MASTER = 'Generated Master Database'
  GENERATED_MATCH = 'Generated Match DB'

  named_scope :raw_db_types, :conditions => ['name in (?)',[UPLOADED_RAW,UPLOADED_CLEANED]]
  named_scope :generated_db_types, :conditions => ['name in (?)',[GENERATED_MASTER, GENERATED_MATCH ]]
  named_scope :database_groups, :conditions => ['name = ?',DATABASE_GROUP]

  has_many :biodatabases
  validates_presence_of :name

  def authorized_for_destroy?
    ![UPLOADED_RAW,UPLOADED_CLEANED,GENERATED_MASTER,GENERATED_MATCH].include? self.name
  end
  def self.database_group
     database_groups.first
  end
end
