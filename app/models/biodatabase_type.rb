class BiodatabaseType < ActiveRecord::Base

  UPLOADED_RAW = 'Uploaded Raw Data'
  UPLOADED_CLEANED = 'Uploaded Cleaned Database'
  GENERATED_MASTER = 'Generated Master Database'
  GENERATED_MATCH = 'Generated Match DB'

  named_scope :raw_db_types, :conditions => ['name in (?)',[UPLOADED_RAW,UPLOADED_CLEANED]]
  named_scope :generated_db_types, :conditions => ['name in (?)',[GENERATED_MASTER, GENERATED_MATCH ]]

  has_many :biodatabases
  validates_presence_of :name

  def authorized_for_destroy?
    ![UPLOADED_RAW,UPLOADED_CLEANED,GENERATED_MASTER,GENERATED_MATCH].include? self.name
  end
end
