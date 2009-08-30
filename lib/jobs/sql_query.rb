class Jobs::SqlQuery < Jobs::AbstractJob
  
  attr_reader :connection_class_name, :query
  
  def initialize(query, connection_class_name = nil)
    @connection_class_name = connection_class_name || 'ActiveRecord::Base'
    @query = query
  end
  
  def do_perform
    connection_class_name.constantize.connection.execute(query)
  end
  
end