module Jobs::Chainable

  def self.included(base)
    base.class_eval do
      alias_method_chain :perform, :chain
    end
  end

  def perform_with_chain
    perform_without_chain
    Job.create!(:job_name => self.next_job_name) if self.respond_to?(:next_job_name)
  end

end