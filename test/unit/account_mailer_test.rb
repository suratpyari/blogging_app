require File.dirname(__FILE__) + '/../test_helper'

class AccountMailerTest < ActionMailer::TestCase
  tests AccountMailer

  def test_sent
    @user = users(:surat_pyari)#User.create(:first_name => "Surat", :last_name => "Pyari", :username => "surat", :password => "surat", :password_confirmation => "surat", :email => "surat@accountmailer.com", :role => 2, :status => 0)
    response = AccountMailer.create_sent(@user)
    assert_equal("New account confirm" , response.subject)
    assert_equal("suratpyari@gmail.com" , response.to[0])
    assert_equal("admin@gmail.com" , response.from[0])
    assert_match(/Dear surat pyari/, response.body)
  end

#  def test_sent
#    @expected.subject = 'AccountMailer#sent'
#    @expected.body    = read_fixture('sent')
#    @expected.date    = Time.now

#    assert_equal @expected.encoded, AccountMailer.create_sent(@expected.date).encoded
#  end

end
