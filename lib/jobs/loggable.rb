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
        message = "#{e.message}\n#{e.backtrace.join("\n")}"
        logger.info "---------------  "
        logger.info "ERROR: "
        logger.info message
        logger.info "---------------  "
        ExceptionNotifier.deliver_exception_notification(e, self, ActionController::Request.new({}) )

      end
      JobLog.create!(:job_name => self.job_name,
                     :job_class_name => self.class.to_s,
                     :started_at => started_at,
                     :stopped_at => stopped_at,
                     :duration_in_seconds => (stopped_at - started_at),
                     :success => e.nil?,
                     :message => message,
                     :user_id => user_id,
                     :project_id => project_id)
      true
    end
  end

end
