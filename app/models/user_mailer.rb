class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
  
    @body[:url]  = "http://gp202.ics.hawaii.edu/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://gp202.ics.hawaii.edu/"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "kenglish@gp202.ics.hawaii.edu"
      @subject     = "[gp202.ics.hawaii.edu] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
