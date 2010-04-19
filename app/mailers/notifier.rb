class Notifier < ActionMailer::Base
  default_url_options[:host] = "gp202.ics.hawaii.edu"

  def password_reset_instructions(user)
    subject      "Password Reset Instructions"
    from          "MEST Notifier <admin@gp202.ics.hawaii.edu>"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => \
                    edit_password_reset_url(user.perishable_token)
  end

end
