class BiodatabaseGroup < ActiveRecord::Base
	acts_as_tree

  belongs_to :user
  belongs_to :project

  has_many :biodatabases

  validates_presence_of :name
  validates_presence_of :user_id
  validates_presence_of :project_id

  validates_uniqueness_of :name, :scope => :project_id


end
