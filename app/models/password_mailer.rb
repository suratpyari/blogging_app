class PasswordMailer < ActionMailer::Base

  def confirm(user)
    @subject      = ''
    @body["user"] = user 
    @recipients   = user.email
    @from         = 'admin@gmail.com'
    @sent_on      = Time.now
    @headers      = {}
  end

  def sent(user,url)
    @subject      = ''
    @body["user"] = user
    @body["url"] = url  
    @recipients   = user.email
    @from         = 'admin@gmail.com'
    @sent_on      = Time.now
    @headers      = {}
  end
end