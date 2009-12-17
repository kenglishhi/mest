class Project < ActiveRecord::Base
  belongs_to :user

  has_many :biodatabases
  has_many :fasta_files
  has_many :uploaded_fasta_files, :class_name =>'FastaFile', :conditions => 'is_generated = 0'

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :user_id
  after_create :create_default_database

  def self.workbench_project_options
    Project.all.map{|p| [p.id,p.name] }
  end

  def create_default_database
    Biodatabase.create!(:name => 'Databases' ,
      :user => self.user,
      :project => self,
      :biodatabase_type => BiodatabaseType.database_group)

  end

  def authorized_for_destroy?
    biodatabases.empty? && fasta_files.empty?
  end


  def ext_tree(params={})
    parent_db = biodatabases.detect{|db | db.parent_id.nil? }
    database_tree_data = parent_db.ext_tree(:expanded => true)

    fasta_file_tree_data = {
      :text =>  "Fasta Files",
      :leaf => fasta_files.empty?,
      :expandable =>  ! fasta_files.empty?,
      :expanded =>  ! fasta_files.empty?,
      :resource => 'fasta_file',
    }

    unless fasta_files.empty?
      fasta_file_tree_data[:children] =  uploaded_fasta_files.map {|fasta_file|
        { :text =>  fasta_file.label,
          :leaf => true,
          :resource => 'fasta_file',
          :id =>  fasta_file.id
        }
      }
    end
    [database_tree_data,fasta_file_tree_data]
  end

end
