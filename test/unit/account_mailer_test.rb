require File.dirname(__FILE__) + '/../test_helper'

class AccountMailerTest < ActionMailer::TestCase
  tests AccountMailer
  def test_sent
    @expected.subject = 'AccountMailer#sent'
    @expected.body    = read_fixture('sent')
    @expected.date    = Time.now

    assert_equal @expected.encoded, AccountMailer.create_sent(@expected.date).encoded
  end

end
