require File.dirname(__FILE__) + '/../../test_helper'

class Admin::CommentsControllerTest < ActionController::TestCase

  def test_accept
    xhr :post, :accept, :id => comments(:comment1_for_post1)
    assert_response :success
  end

  def test_destroy
    post :destroy, {:id => comments(:comment1_for_post1), :post_id => comments(:comment1_for_post1).commentable_id, '_method' => 'delete'}, {:user_id => posts(:post1).user_id}
    assert_redirected_to admin_post_comments_path(1)
  end

  def test_destroy_without_user
    post :destroy, {:id => comments(:comment1_for_post1), :post_id => comments(:comment1_for_post1).commentable_id, '_method' => 'delete'}
    assert_redirected_to '/'
    assert_equal "Login required", flash[:msg]
  end

  def test_destroy_invalid_user
    post :destroy, {:id => comments(:comment1_for_post1), :post_id => comments(:comment1_for_post1).commentable_id, '_method' => 'delete'}, {:user_id => users(:not_admin).id}
    assert_redirected_to dashboard_path
  end

  def test_destroy_wrong_comment
    post :destroy, {:id => 47534897, :post_id => comments(:comment1_for_post1).commentable_id, '_method' => 'delete'}, {:user_id => users(:not_admin).id}
    assert_redirected_to dashboard_path
    assert_equal "This comment does not exists", flash[:msg]
  end

end
