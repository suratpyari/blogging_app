require File.dirname(__FILE__) + '/../test_helper'

class CommentsControllerTest < ActionController::TestCase

  def test_create_comment
    xhr :post, :create, {:comment => {:content => "some content",
                              :author => "surat",
                              :email => "surat@vinsol.com",
                              :status => 0}, :post_id => 1}
    assert_response :success
  end

  def test_create_spam
    xhr :post, :create, {:comment => {:content => "some content",
                              :author => "s-u-r-a-t",
                              :email => "surat@vinsol.com",
                              :status => 0}, :post_id => 1}
    assert_response :success
  end
  
  def test_create_bad_parameters
    xhr :post, :create, {:comment => {:content => "",
                              :author => "",
                              :email => "",
                              :status => 0}, :post_id => 1}
  end

  def test_accept
    xhr :post, :accept, :id => comments(:comment1_for_post1)
    assert_response :success
  end

  def test_destroy
    xhr :post, :destroy, {:id => comments(:comment1_for_post1), :post_id => posts(:post1).id}, {:user_id => posts(:post1).user_id}
  end

end
