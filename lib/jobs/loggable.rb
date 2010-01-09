module Jobs::Loggable

  def self.included(base)
    base.class_eval do
      alias_method_chain :perform, :logging
    end
  end

  def perform_with_logging
    started_at = Time.now
    begin
      perform_without_logging
    rescue => e
      raise e
    ensure
      stopped_at = Time.now
      if e
        JobFailureNotifier.deliver_failure_notification(e,self) unless RAILS_ENV =='test'
        message = "#{e.message}\n#{e.backtrace.join("\n")}"
        logger.info "---------------  "
        logger.info "ERROR: "
        logger.info message
        logger.info "---------------  "
      end

      estimated_completion_date = nil
      estimation_error_seconds = 0
      if Job.exists?(job_id)
        estimated_completion_date  = Job.find(job_id).estimated_completion_date
        estimation_error_seconds = estimated_completion_date  - stopped_at
      end
      JobLog.create!(:job_name => self.job_name,
        :job_class_name => self.class.to_s,
        :started_at => started_at,
        :stopped_at => stopped_at,
        :duration_in_seconds => (stopped_at - started_at),
        :success => e.nil?,
        :message => message,
        :estimated_completion_date => estimated_completion_date ,
        :estimation_error_seconds =>estimation_error_seconds ,
        :user_id => user_id,
        :project_id => project_id)
      true
    end
  end

end
