class Jobs::BaseController < ApplicationController
  before_filter :job_sub_nav
  private

  def job_sub_nav
   @content_for_sub_nav = render_to_string(:partial => 'jobs/base/jobs_sub_nav')
  end
end
