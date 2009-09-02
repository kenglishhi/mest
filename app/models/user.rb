class User < ActiveRecord::Base
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  has_many :fasta_files
  has_many :job_logs
  has_many :jobs

  acts_as_authentic do | config |
    config.login_field = 'email'
  end

  # for active scaffold
  def label
    email
  end

  def full_name
    full_name = "#{first_name} #{last_name}"
    full_name << ", #{title} " unless title.blank?
    full_name
  end
end
