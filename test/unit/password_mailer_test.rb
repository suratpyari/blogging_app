require File.dirname(__FILE__) + '/../test_helper'

class PasswordMailerTest < ActionMailer::TestCase
  tests PasswordMailer

  def test_sent
    user = users(:surat_pyari)
    user.update_attribute('token',Digest::SHA1.hexdigest(rand.to_s))
    url = edit_password_users_path(:token => user.token, :only_path => false) 
    response = PasswordMailer.create_sent(user)
    assert_equal("Change your password" , response.subject)
    assert_equal("suratpyari@gmail.com" , response.to[0])
    assert_equal("admin@gmail.com" , response.from[0])
    assert_match(/Dear surat pyari/, response.body)
  end

end
