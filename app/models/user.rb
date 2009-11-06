class User < ActiveRecord::Base
  include ExtJS::Model
  extjs_fields :id, :first_name, :last_name, :email, :updated_at, :created_at

  validates_presence_of :first_name, :last_name, :email

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  has_many :fasta_files
  has_many :job_logs
  has_many :jobs
  has_many :projects
  belongs_to :default_project,:class_name => "Project"

  after_create :create_default_project
  attr_accessor :active_project

  acts_as_authentic do | config |
    config.login_field = 'email'
  end

  def create_default_project
    self.default_project = Project.new(:name => "#{self.first_name} #{self.last_name} Project 1",
      :description => "This is the default project for #{self.first_name} #{self.last_name}",
      :user => self)
    self.save
    biodatabase_group = BiodatabaseGroup.create(:name => 'Main Group',:user => self,
      :project => self.default_project)

  end


  # for active scaffold
  def label
    email
  end
  def active_project
    if @active_project  
      @active_project
    else
      self.default_project
    end

  end

  def full_name
    full_name = "#{first_name} #{last_name}"
    full_name << ", #{title} " unless title.blank?
    full_name
  end

end
