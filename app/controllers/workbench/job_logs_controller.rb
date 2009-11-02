class Workbench::JobLogsController < ApplicationController
  include ExtJS::Controller

  def index
    page = get_page(Job)
    data = JobLog.paginate :page => page, :order => 'id desc'

    results = JobLog.count
    render :json => {:results => results, :data => data.map{|row|row.to_record}}
  end
end