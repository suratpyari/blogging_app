require File.dirname(__FILE__) + '/../test_helper'

class CommentsControllerTest < ActionController::TestCase

  def test_create_comment
    xhr :post, :create, {:comment => {:content => "some content",
                              :author => "surat",
                              :email => "surat@vinsol.com",
                              :status => 0}, :post_id => 1}
    assert_response :success
  #  assert_equal 0, assigns["comment"].status
 #   p @response.body
#    assert_select_rjs "#flash"
    #, "This comment has been submitted"
    #assert_select 'div#comment_errors', ""
  end

  def test_create_spam
    xhr :post, :create, {:comment => {:content => "some content",
                              :author => "viagra-test-123",
                              :email => "surat@vinsol.com",
                              :status => 0}, :post_id => 1}
    assert_response :success
    assert_equal 2, assigns["comment"].status
   # assert_select 'div#flash', "Your comment looks like spam and will show up once admin approves"
   # assert_select 'div#comment_errors', ""
  end
  
  def test_create_bad_parameters
    xhr :post, :create, {:comment => {:content => "",
                              :author => "",
                              :email => "",
                              :status => 0}, :post_id => 1}
    #assert_select 'div#comment_errors', ""
  end

end
