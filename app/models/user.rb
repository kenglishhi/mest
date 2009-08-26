class User < ActiveRecord::Base
  acts_as_authentic do | config |
    config.login_field = 'email'
  end

  # for active scaffold
  def label
    email
  end

end
