class BiodatabaseGroup < ActiveRecord::Base
	acts_as_tree

  belongs_to :user
  belongs_to :project

  has_many :biodatabases

  validates_presence_of :name
  validates_presence_of :user_id
  validates_presence_of :project_id

  validates_uniqueness_of :name, :scope => :project_id
  def ext_tree
    tree_data = { :text =>  self.name,
      :expanded => true,
      :leaf => false,
      :id => self.id,
      :expandable => true


    }
    tree_data[:children] =  []
    tree_data[:children] +=  biodatabases.map{ |db| {:text => db.name, :leaf => true}  }
    tree_data[:children] +=  children.map{ |db_group| db_group.ext_tree  }
    tree_data

  end

end
