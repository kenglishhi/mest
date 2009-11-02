class Workbench::JobsController < ApplicationController
  include ExtJS::Controller

  def index
    page = get_page(Job)
    if params[:option] == 'Queued'
      data = Job.paginate :page => page, :conditions => 'locked_at is null'
      results = Job.count 'locked_at is null'
    elsif params[:option] == 'Failed'
      data = Job.paginate :page => page, :conditions => 'failed_at is not null'
      results = Job.count 'failed_at is not null'
    else # else is always RUNNING!
      data = Job.paginate :page => page, :conditions => 'locked_at is not null'
      results = Job.count 'locked_at is not null'
    end
    render :json => {:results => results, :data => data.map{|row|row.to_record}}

  end
end