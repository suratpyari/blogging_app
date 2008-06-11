require File.dirname(__FILE__) + '/../test_helper'

class PasswordMailerTest < ActionMailer::TestCase
  tests PasswordMailer
  def test_sent
    @expected.subject = 'PasswordMailer#sent'
    @expected.body    = read_fixture('sent')
    @expected.date    = Time.now

    assert_equal @expected.encoded, PasswordMailer.create_sent(@expected.date).encoded
  end

end
