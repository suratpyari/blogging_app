class AccountMailer < ActionMailer::Base

  def confirm(user)
    @subject      = 'New account confirm'
    @body["user"] = user 
    @recipients   = user.email
    @from         = 'admin@gmail.com'
    @sent_on      = Time.now
    @headers      = {}
  end

  def sent(user)
    @subject      = 'New account confirm'
    @body["user"] = user 
    @recipients   = user.email
    @from         = 'admin@gmail.com'
    @sent_on      = Time.now
    @headers      = {}
  end
end
