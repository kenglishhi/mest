class Workbench::JobsController < ApplicationController
  include ExtJS::Controller
  protect_from_forgery :except => :destroy

  def index
    page = get_page(Job)
    if params[:option] == 'Queued'
      data = Job.paginate :page => page, :conditions => 'locked_at is null AND failed_at is null AND last_error is null'
    elsif params[:option] == 'Failed'
      data = Job.paginate :page => page, :conditions => 'failed_at is not null'
    else # else is always RUNNING!
      data = Job.paginate :page => page, :conditions => 'locked_at is not null AND last_error is null'
    end
    render :json => {:results => data.size, :data => data.map{|row|row.to_record}}
  end

  def destroy
    @job = Job.find(params[:id])

    if @job.destroy
      render :json => { :success => true, :message => "Destroyed job #{@job.name}" }
    else
      render :json => { :message => "Failed to destroy Job" }
    end
  end

end