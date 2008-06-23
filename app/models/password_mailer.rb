class PasswordMailer < ActionMailer::Base

  def sent(user,url)
    @subject      = 'Change your password'
    @body["user"] = user
    @body["url"]  = url
    @recipients   = user.email
    @from         = 'admin@gmail.com'
    @sent_on      = Time.now
    @headers      = {}
  end

end
