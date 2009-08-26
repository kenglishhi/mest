class User < ActiveRecord::Base
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  acts_as_authentic do | config |
    config.login_field = 'email'
  end

  # for active scaffold
  def label
    email
  end

  def full_name
    str = "#{first_name} #{last_name}"
    str << ", #{title} " if title
  end
end
