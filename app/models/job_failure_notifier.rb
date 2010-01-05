class JobFailureNotifier < ActionMailer::Base
  @@sender_address = %("Exception Notifier" <exception.notifier@default.com>)
  cattr_accessor :sender_address

  @@exception_recipients = []
  cattr_accessor :exception_recipients

  @@email_prefix = "[ERROR] "
  cattr_accessor :email_prefix

  def failure_notification(exception,job,data={})
    content_type "text/plain"

    subject    "#{email_prefix}#{job.class.to_s}# (#{exception.class}) #{exception.message.inspect}"

    recipients exception_recipients
    from       sender_address

    body       data.merge({ 
        :exception => exception,
        :params => job.params,
        :job => job,
        :backtrace => sanitize_backtrace(exception.backtrace),
        :data => data,
      })

  end
  private

  def sanitize_backtrace(trace)
    re = Regexp.new(/^#{Regexp.escape(rails_root)}/)
    trace.map { |line| Pathname.new(line.gsub(re, "[RAILS_ROOT]")).cleanpath.to_s }
  end
  def rails_root
    @rails_root ||= Pathname.new(RAILS_ROOT).cleanpath.to_s
  end

end
