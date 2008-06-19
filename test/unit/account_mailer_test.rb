require File.dirname(__FILE__) + '/../test_helper'

class AccountMailerTest < ActionMailer::TestCase
  tests AccountMailer

  def test_sent
    user = users(:surat_pyari)
    response = AccountMailer.create_sent(user)
    assert_equal("New account confirm" , response.subject)
    assert_equal("suratpyari@gmail.com" , response.to[0])
    assert_equal("admin@gmail.com" , response.from[0])
    assert_match(/Dear surat pyari/, response.body)
  end

end
