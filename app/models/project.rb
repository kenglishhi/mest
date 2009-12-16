class Project < ActiveRecord::Base
  belongs_to :user

  has_many :biodatabases
  has_many :fasta_files

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :user_id
  after_create :create_default_database

  def create_default_database
    Biodatabase.create!(:name => 'Databases' ,
      :user => self.user,
      :project => self,
      :biodatabase_type => BiodatabaseType.database_group)

  end

  def authorized_for_destroy?
    biodatabases.empty? && fasta_files.empty?
  end

  def self.workbench_project_options
    Project.all.map{|p| [p.id,p.name] }
  end
  def ext_tree(params={})
    parent_db = biodatabases.detect{|db | db.parent_id.nil? }
    database_tree_data = parent_db.ext_tree

    fasta_file_tree_data = {
      :text =>  "Fasta Files",
      :leaf => false,
      :expandable => true,
      :resource => 'fasta_files',
    }

    unless fasta_files.empty?
      fasta_file_tree_data[:children] =  fasta_files.map {|fasta_file|
        {:text =>  fasta_file.label,
          :leaf => true,
          :resource => 'fasta_files',
        }
      }
    end
    [database_tree_data,fasta_file_tree_data]
  end

end
