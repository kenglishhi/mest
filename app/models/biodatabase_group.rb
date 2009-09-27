class BiodatabaseGroup < ActiveRecord::Base
  acts_as_tree

  belongs_to :user
  belongs_to :project

  has_many :biodatabases

  validates_presence_of :name
  validates_presence_of :user_id
  validates_presence_of :project_id

  validates_uniqueness_of :name, :scope => :project_id
  def ext_tree(params={})
    tree_data = { :text =>  self.name,
      :leaf => false,
      :id => self.id,
      :expandable => true,
      :resource => 'biodatabase_group'
    }
		tree_data[:expanded] = true if params[:expand_node]
    tree_data[:children] =  []
    tree_data[:children] +=  biodatabases.map do  |db|
      {:text => db.name, :leaf => true, :id => db.id, :resource => 'biodatabase' }
    end
    tree_data[:children] +=  children.map{ |db_group| db_group.ext_tree  }
    tree_data

  end

end
