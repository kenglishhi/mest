class BiodatabaseGroup < ActiveRecord::Base
  acts_as_tree

  include ExtJS::Model
  extjs_fields :id, :name,:created_at

  belongs_to :user
  belongs_to :project

  has_many :biodatabases, :dependent => :destroy, :order => 'name'

  validates_presence_of :name
  validates_presence_of :user_id
  validates_presence_of :project_id
  named_scope :main_group_in_project, lambda {|project|
    {:conditions =>  [' project_id = ? AND parent_id is null', project.id],
      :limit => 1
    }
  }


  validates_uniqueness_of :name, :scope => :project_id

  cattr_reader :per_page
  @@per_page = 10

  def ext_tree
    nil
  end
#  def ext_tree(params={})
#    tree_data = { :text =>  self.name,
#      :leaf => false,
#      :id => self.id,
#      :expandable => true,
#      :resource => 'biodatabase_group'
#    }
#    tree_data[:expanded] = true if params[:expand_node]
#    tree_data[:children] =  []
#    tree_data[:children] +=  children.map do  |db_group|
#      db_group.ext_tree
#    end
#    tree_data[:children] +=  biodatabases.map do  |db|
#      {:text => db.name, :leaf => true, :id => db.id, :resource => 'biodatabase', :db_type=> db.biodatabase_type.name  }
#    end
#    tree_data
#  end

end
