require File.dirname(__FILE__) + '/../test_helper'

class CommentsControllerTest < ActionController::TestCase

  def test_create
    xhr :post, :create, {:comment => {:content => "some content",
                              :author => "surat",
                              :email => "surat@vinsol.com",
                              :commentable_type => "post",
                              :commentable_id => 1,
                              :status => 0}, :post_id => 1}
    assert_response :success
  end

  def test_accept
    xhr :post, :accept, :id => comments(:comment1_for_post1)
    assert_response :success
  end

  def test_destroy
    xhr :post, :destroy, {:id => comments(:comment1_for_post1), :post_id => 1, :method => :delete}, {:user_id => users(:surat_pyari).id}
  end

end
