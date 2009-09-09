class BlastResult < ActiveRecord::Base
  has_attached_file :output
  belongs_to :job_log
end
