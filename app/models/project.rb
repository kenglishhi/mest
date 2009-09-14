class Project < ActiveRecord::Base
  belongs_to :user

  has_many :biodatabase_groups
  has_many :fasta_files

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :user_id

  def authorized_for_destroy?
    biodatabase_groups.empty? && fasta_files.empty?
  end
  def self.workbench_project_options
    Project.all.map{|p| [p.id,p.name] }
  end
end
